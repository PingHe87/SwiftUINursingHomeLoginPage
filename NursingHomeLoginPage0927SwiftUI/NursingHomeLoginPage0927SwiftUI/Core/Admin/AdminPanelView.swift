//
//  AdminPanelView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/14/24.
//

import SwiftUI
import FirebaseFirestore

struct AdminPanelView: View {
    @State private var inviteCodes: [Invite] = [] // 邀请码列表
    @State private var users: [User] = [] // 用户列表
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            List {
                // 邀请码列表
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

                // 用户列表
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
                        fetchInviteCodes() // 刷新邀请码
                        fetchUsers() // 刷新用户列表
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
