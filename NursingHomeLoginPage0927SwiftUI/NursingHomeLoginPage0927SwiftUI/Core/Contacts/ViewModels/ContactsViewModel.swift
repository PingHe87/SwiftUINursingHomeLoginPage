//
//  ContactsViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ContactsViewModel: ObservableObject {
    @Published var groupedContacts: [String: [Contact]] = [:]
    @Published var searchText: String = "" {
        didSet {
            filterAndGroupContacts()
        }
    }
    
    private var contacts: [Contact] = []
    private let db = Firestore.firestore()

    init() {
        Task {
            await loadContacts()
        }
    }
    
    /// Load contacts of the current user from Firestore
    private func loadContacts() async {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No logged-in user.")
            return
        }

        do {
            // Fetch the current user's document
            let userDoc = try await db.collection("users").document(currentUserID).getDocument()
            
            // Retrieve the contact IDs from the user's document
            guard let contactIDs = userDoc.data()?["contacts"] as? [String], !contactIDs.isEmpty else {
                print("No contacts found for the current user.")
                return
            }
            
            // Query Firestore for user documents matching the contact IDs
            let snapshot = try await db.collection("users")
                .whereField(FieldPath.documentID(), in: contactIDs)
                .getDocuments()
            
            // Map Firestore documents to Contact models
            let loadedContacts = snapshot.documents.compactMap { document -> Contact? in
                guard let firstName = document.data()["firstName"] as? String,
                      let lastName = document.data()["lastName"] as? String,
                      let email = document.data()["email"] as? String,
                      let role = document.data()["role"] as? String else {
                    return nil
                }
                let fullName = "\(firstName) \(lastName)"
                return Contact(
                    id: document.documentID,
                    name: fullName,
                    email: email,
                    role: role
                )
            }
            
            // Update the contacts list and group them by role
            DispatchQueue.main.async {
                self.contacts = loadedContacts
                self.filterAndGroupContacts()
            }
        } catch {
            print("Error loading contacts: \(error.localizedDescription)")
        }
    }
    
    /// Filter and group contacts based on the search text and roles
    private func filterAndGroupContacts() {
        let filtered = searchText.isEmpty
            ? contacts
            : contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        
        groupedContacts = Dictionary(grouping: filtered, by: { $0.role.capitalized })
    }
}
