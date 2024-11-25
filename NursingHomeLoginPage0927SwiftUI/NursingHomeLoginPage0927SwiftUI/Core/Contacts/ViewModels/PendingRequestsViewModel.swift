//
//  PendingRequestsViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import FirebaseFirestore
import FirebaseAuth

class PendingRequestsViewModel: ObservableObject {
    @Published var pendingRequests: [User] = []
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        startListeningForPendingRequests()
    }
    
    deinit {
        listener?.remove()
    }

    private func startListeningForPendingRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        listener = db.collection("users").document(currentUserID).addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            if let requestIDs = data["pendingRequests"] as? [String] {
                Task {
                    await self?.fetchPendingRequestUsers(userIDs: requestIDs)
                }
            }
        }
    }

    private func fetchPendingRequestUsers(userIDs: [String]) async {
        do {
            let snapshot = try await db.collection("users")
                .whereField(FieldPath.documentID(), in: userIDs)
                .getDocuments()

            let users = snapshot.documents.compactMap { document -> User? in
                try? document.data(as: User.self)
            }

            DispatchQueue.main.async {
                self.pendingRequests = users
            }
        } catch {
            print("Error fetching pending request users: \(error.localizedDescription)")
        }
    }

    func acceptRequest(from requesterID: String) async {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        do {
            let currentUserRef = db.collection("users").document(currentUserID)
            let requesterRef = db.collection("users").document(requesterID)

            try await db.runTransaction { transaction, _ in
                if let currentUserDoc = try? transaction.getDocument(currentUserRef),
                   let currentContacts = currentUserDoc["contacts"] as? [String],
                   let currentPendingRequests = currentUserDoc["pendingRequests"] as? [String] {
                    
                    var updatedContacts = currentContacts
                    updatedContacts.append(requesterID)
                    
                    var updatedPendingRequests = currentPendingRequests
                    updatedPendingRequests.removeAll { $0 == requesterID }
                    
                    transaction.updateData(["contacts": updatedContacts, "pendingRequests": updatedPendingRequests], forDocument: currentUserRef)
                }

                if let requesterDoc = try? transaction.getDocument(requesterRef),
                   let requesterContacts = requesterDoc["contacts"] as? [String] {
                    
                    var updatedRequesterContacts = requesterContacts
                    updatedRequesterContacts.append(currentUserID)
                    
                    transaction.updateData(["contacts": updatedRequesterContacts], forDocument: requesterRef)
                }
                
                return nil
            }
        } catch {
            print("Error accepting friend request: \(error.localizedDescription)")
        }
    }

    func rejectRequest(from requesterID: String) async {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        do {
            let currentUserRef = db.collection("users").document(currentUserID)
            try await currentUserRef.updateData([
                "pendingRequests": FieldValue.arrayRemove([requesterID])
            ])
        } catch {
            print("Error rejecting friend request: \(error.localizedDescription)")
        }
    }
}
