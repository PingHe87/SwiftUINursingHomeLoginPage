//
//  ContactsViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/23/24.
//


import Foundation
import FirebaseFirestore

class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contact] = [] // List of loaded contacts
    @Published var receivedRequests: [Contact] = [] // Received friend requests

    private let db = Firestore.firestore()
    
    var groupedContacts: [Contact.Role: [Contact]] {
           Dictionary(grouping: contacts, by: { $0.role })
       }

    /// Fetch all contacts for the current user
    func fetchContacts(for userId: String) async {
        do {
            let userDoc = try await db.collection("users").document(userId).getDocument()
            guard let userData = userDoc.data(),
                  let contactIds = userData["contacts"] as? [String] else {
                print("No contacts found for user \(userId)")
                return
            }

            var tempContacts: [Contact] = []
            for contactId in contactIds {
                let contactDoc = try await db.collection("users").document(contactId).getDocument()
                if let contact = parseContact(from: contactDoc) {
                    tempContacts.append(contact)
                }
            }

            DispatchQueue.main.async {
                self.contacts = tempContacts
            }
        } catch {
            print("Error fetching contacts: \(error.localizedDescription)")
        }
    }

    /// Fetch friend requests for the current user
    func fetchFriendRequests(for userId: String) async {
        do {
            let userDoc = try await db.collection("users").document(userId).getDocument()
            guard let userData = userDoc.data(),
                  let requestIds = userData["receivedRequests"] as? [String] else {
                print("No received requests for user \(userId)")
                return
            }

            var tempRequests: [Contact] = []
            for requestId in requestIds {
                let requestDoc = try await db.collection("users").document(requestId).getDocument()
                if let contact = parseContact(from: requestDoc) {
                    tempRequests.append(contact)
                }
            }

            DispatchQueue.main.async {
                self.receivedRequests = tempRequests
            }
        } catch {
            print("Error fetching friend requests: \(error.localizedDescription)")
        }
    }

    /// Search users by name in Firestore (Prefix Search)
    func searchUsers(byName name: String) async throws -> [Contact] {
        var results: [Contact] = []
        let firstNameQuery = db.collection("users")
            .whereField("firstName", isGreaterThanOrEqualTo: name)
            .whereField("firstName", isLessThanOrEqualTo: name + "\u{f8ff}")
        let lastNameQuery = db.collection("users")
            .whereField("lastName", isGreaterThanOrEqualTo: name)
            .whereField("lastName", isLessThanOrEqualTo: name + "\u{f8ff}")

        do {
            let firstNameSnapshot = try await firstNameQuery.getDocuments()
            for document in firstNameSnapshot.documents {
                if let contact = parseContact(from: document) {
                    results.append(contact)
                }
            }

            let lastNameSnapshot = try await lastNameQuery.getDocuments()
            for document in lastNameSnapshot.documents {
                if let contact = parseContact(from: document) {
                    results.append(contact)
                }
            }

            results = Array(Set(results)) // Remove duplicates based on `id`
        } catch {
            print("Error searching users by name: \(error.localizedDescription)")
            throw error
        }

        return results
    }

    /// Helper function to parse Firestore document into Contact object
    private func parseContact(from document: DocumentSnapshot) -> Contact? {
        guard let data = document.data(),
              let id = data["id"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let email = data["email"] as? String,
              let role = data["role"] as? String else {
            print("Debug: Missing required fields in document: \(document.documentID)")
            return nil
        }

        let profileImage = data["profileImage"] as? String
        let isOnline = data["isOnline"] as? Bool ?? false
        let lastMessagePreview = data["lastMessagePreview"] as? String
        let status = Contact.ContactStatus(rawValue: data["status"] as? String ?? "notFriend") ?? .notFriend

        let fullName = "\(firstName) \(lastName)"
        let roleEnum = Contact.Role(rawValue: role) ?? .resident

        return Contact(
            id: id,
            fullName: fullName,
            email: email,
            profileImage: profileImage,
            role: roleEnum,
            isOnline: isOnline,
            lastMessagePreview: lastMessagePreview,
            status: status
        )
    }

    /// Send a friend request
    func sendFriendRequest(currentUserId: String, friendId: String) async throws {
        let currentUserRef = db.collection("users").document(currentUserId)
        let friendUserRef = db.collection("users").document(friendId)

        do {
            try await currentUserRef.updateData([
                "pendingRequests": FieldValue.arrayUnion([friendId])
            ])
            try await friendUserRef.updateData([
                "receivedRequests": FieldValue.arrayUnion([currentUserId])
            ])
        } catch {
            print("Error sending friend request: \(error.localizedDescription)")
            throw error
        }
    }

    /// Accept a friend request
    func acceptFriendRequest(currentUserId: String, friendId: String) async throws {
        let currentUserRef = db.collection("users").document(currentUserId)
        let friendUserRef = db.collection("users").document(friendId)

        do {
            try await currentUserRef.updateData([
                "contacts": FieldValue.arrayUnion([friendId]),
                "receivedRequests": FieldValue.arrayRemove([friendId])
            ])
            try await friendUserRef.updateData([
                "contacts": FieldValue.arrayUnion([currentUserId]),
                "pendingRequests": FieldValue.arrayRemove([currentUserId])
            ])
        } catch {
            print("Error accepting friend request: \(error.localizedDescription)")
            throw error
        }
    }
}
