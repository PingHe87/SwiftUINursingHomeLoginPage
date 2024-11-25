//
//  AddFriendViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddFriendViewModel: ObservableObject {
    @Published var searchResults: [User] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var requestSent: Bool = false

    private let db = Firestore.firestore()

    /// Search for users in Firestore
    func searchUsers() async {
        guard !searchText.isEmpty else { return }

        DispatchQueue.main.async {
            self.isLoading = true
        }

        do {
            // Fetch all users (not ideal for large datasets)
            let snapshot = try await db.collection("users").getDocuments()

            let users = snapshot.documents.compactMap { document -> User? in
                let data = document.data()
                guard let firstName = data["firstName"] as? String,
                      let lastName = data["lastName"] as? String,
                      let email = data["email"] as? String,
                      let role = data["role"] as? String else {
                    return nil
                }
                
                // Dynamically create fullName and filter by searchText
                let fullName = "\(firstName) \(lastName)"
                if fullName.lowercased().contains(self.searchText.lowercased()) {
                    return User(
                        id: document.documentID,
                        firstName: firstName,
                        middleName: nil,
                        lastName: lastName,
                        email: email,
                        role: role,
                        contacts: [],
                        pendingRequests: []
                    )
                }
                return nil
            }

            DispatchQueue.main.async {
                self.searchResults = users
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    /// Send a friend request to a user
    func sendFriendRequest(to userID: String) async {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        do {
            // Update the target user's `pendingRequests` field
            let userRef = db.collection("users").document(userID)
            try await userRef.updateData([
                "pendingRequests": FieldValue.arrayUnion([currentUserID])
            ])
            
            DispatchQueue.main.async {
                self.requestSent = true
            }
        } catch {
            // Handle any errors if necessary
        }
    }
}
