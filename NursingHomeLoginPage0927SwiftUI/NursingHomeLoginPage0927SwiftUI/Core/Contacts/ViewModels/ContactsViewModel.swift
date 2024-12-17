//
//  ContactsViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import FirebaseFirestore
import FirebaseAuth

class ContactsViewModel: ObservableObject {
    @Published var groupedContacts: [String: [Contact]] = [:] // Original grouped contacts
    @Published var filteredContacts: [String: [Contact]] = [:] // Filtered contacts for search
    @Published var pendingRequestsCount: Int = 0

    private var contacts: [Contact] = [] // Raw contacts
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        Task {
            await loadContacts()
        }
        startListeningForPendingRequests()
    }

    deinit {
        listener?.remove()
    }

    /// Load contacts and group them
    private func loadContacts() async {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No logged-in user.")
            return
        }

        do {
            let userDoc = try await db.collection("users").document(currentUserID).getDocument()
            guard let contactIDs = userDoc.data()?["contacts"] as? [String], !contactIDs.isEmpty else {
                return
            }

            let snapshot = try await db.collection("users")
                .whereField(FieldPath.documentID(), in: contactIDs)
                .getDocuments()

            let loadedContacts = snapshot.documents.compactMap { document -> Contact? in
                guard let firstName = document.data()["firstName"] as? String,
                      let lastName = document.data()["lastName"] as? String,
                      let email = document.data()["email"] as? String,
                      let role = document.data()["role"] as? String else {
                    return nil
                }
                let tags = document.data()["tags"] as? [String] ?? [] // Load tags safely
                let fullName = "\(firstName) \(lastName)"
                return Contact(
                    id: document.documentID,
                    name: fullName,
                    email: email,
                    role: role,
                    tags: tags // Pass tags to the Contact model
                )
            }

            DispatchQueue.main.async {
                self.contacts = loadedContacts
                self.groupedContacts = Dictionary(grouping: loadedContacts, by: { $0.role.capitalized })
                self.filteredContacts = self.groupedContacts
            }
        } catch {
            print("Error loading contacts: \(error.localizedDescription)")
        }
    }

    /// Filter contacts based on search text or tag
    func filterContacts(by tag: String) {
        if tag.isEmpty {
            filteredContacts = groupedContacts
        } else {
            filteredContacts = groupedContacts.mapValues { contacts in
                contacts.filter { $0.tags.contains(tag) }
            }
        }
    }

    /// Start listening for pending requests count
    private func startListeningForPendingRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        listener = db.collection("users").document(currentUserID).addSnapshotListener { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }

            if let requestIDs = data["pendingRequests"] as? [String] {
                DispatchQueue.main.async {
                    self?.pendingRequestsCount = requestIDs.count
                }
            }
        }
    }

    /// Add a tag to a contact
    func addTag(to contactID: String, tag: String) async {
        let contactRef = db.collection("users").document(contactID)

        do {
            try await contactRef.updateData([
                "tags": FieldValue.arrayUnion([tag])
            ])
        } catch {
            print("Error adding tag: \(error.localizedDescription)")
        }
    }

    /// Remove a tag from a contact
    func removeTag(from contactID: String, tag: String) async {
        let contactRef = db.collection("users").document(contactID)

        do {
            try await contactRef.updateData([
                "tags": FieldValue.arrayRemove([tag])
            ])
        } catch {
            print("Error removing tag: \(error.localizedDescription)")
        }
    }
}

