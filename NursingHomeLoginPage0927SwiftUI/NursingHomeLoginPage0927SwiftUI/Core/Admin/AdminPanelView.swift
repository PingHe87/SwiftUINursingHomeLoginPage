//
//  AdminPanelView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/14/24.
//

import SwiftUI
import FirebaseFirestore

struct AdminPanelView: View {
    @State private var inviteCodes: [Invite] = [] // List of invite codes
    @State private var users: [User] = [] // List of users
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            List {
                // Invite Code Section
                Section(header: Text("Invite Codes")) {
                    ForEach(inviteCodes) { invite in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Invite Code: \(invite.code)")
                                .font(.headline)
                            Text("Status: \(invite.isUsed ? "Used" : "Unused")")
                                .foregroundColor(invite.isUsed ? .green : .red)
                            if let usedBy = invite.usedBy {
                                Text("Used by: \(usedBy)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    }
                }

                // User List Section
                Section(header: Text("Users")) {
                    ForEach(users) { user in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name: \(user.fullName)")
                                .font(.headline)
                            Text("Email: \(user.email)")
                                .font(.subheadline)
                            Text("Role: \(user.role.capitalized)")
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Admin Panel")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        fetchInviteCodes() // Refresh invite codes
                        fetchUsers() // Refresh user list
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            fetchInviteCodes()
            fetchUsers()
        }
    }

    // Fetch invite codes from Firestore
    func fetchInviteCodes() {
        let db = Firestore.firestore()
        db.collection("invites").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching invite codes: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            self.inviteCodes = documents.compactMap { doc -> Invite? in
                try? doc.data(as: Invite.self)
            }
        }
    }

    // Fetch users from Firestore
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            self.users = documents.compactMap { doc -> User? in
                try? doc.data(as: User.self)
            }
        }
    }
}

