//
//  ContactsViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import FirebaseFirestore
import FirebaseAuth

class ContactsViewModel: ObservableObject {
    @Published var groupedContacts: [String: [Contact]] = [:]
    @Published var searchText: String = "" {
        didSet {
            filterAndGroupContacts()
        }
    }
    @Published var pendingRequestsCount: Int = 0

    private var contacts: [Contact] = []
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

    /// Load contacts of the current user from Firestore
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
