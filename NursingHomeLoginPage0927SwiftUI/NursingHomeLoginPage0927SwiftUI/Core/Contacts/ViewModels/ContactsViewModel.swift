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
                let fullName = "\(firstName) \(lastName)"
                return Contact(
                    id: document.documentID,
                    name: fullName,
                    email: email,
                    role: role
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

    /// Filter contacts based on search text
    func filterContacts(by searchText: String) {
        if searchText.isEmpty {
            filteredContacts = groupedContacts // Show all contacts if search is empty
        } else {
            filteredContacts = groupedContacts.mapValues { contacts in
                contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
}

