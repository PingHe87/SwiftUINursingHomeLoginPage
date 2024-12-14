//
//  InviteView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/14/24.
//

import SwiftUI

struct InviteView: View {
    @State private var email = "" // Input for the invitee's email
    @State private var inviteCode = "" // Generated invite code
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedRole = "relative" // Default role
    @State private var showCopyAlert = false // Alert for copy-to-clipboard success
    @EnvironmentObject var authViewModel: AuthViewModel

    let userRole: String // Current user's role

    // Define roles based on user type
    var availableRoles: [String] {
        if userRole == "admin" {
            return ["resident", "staff", "relative"] // Admin can invite all roles
        } else {
            return ["relative"] // Regular users can only invite relatives
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Invite a User")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Invitee Email Input
            InputView(text: $email,
                      title: "Invitee's Email",
                      placeholder: "Enter their email address")
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()

            // Role Picker (Admin can pick all roles, users only 'relative')
            VStack(alignment: .leading) {
                Text("Select Role")
                    .font(.headline)
                Picker("Role", selection: $selectedRole) {
                    ForEach(availableRoles, id: \.self) { role in
                        Text(role.capitalized).tag(role)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()

            // Generate Invite Code Button
            Button(action: {
                Task {
                    do {
                        inviteCode = try await authViewModel.generateInviteCode(for: email, role: selectedRole)
                        alertMessage = "Invite Code Generated: \(inviteCode)"
                        showAlert = true
                    } catch {
                        alertMessage = "Error: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }) {
                Text("Generate Invite Code")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(email.isEmpty)
            .opacity(email.isEmpty ? 0.5 : 1.0)

            // Show Generated Invite Code with Copy Button
            if !inviteCode.isEmpty {
                VStack(spacing: 10) {
                    Text("Invite Code:")
                        .font(.headline)
                    Text(inviteCode)
                        .font(.body)
                        .foregroundColor(.green)

                    Button(action: {
                        UIPasteboard.general.string = inviteCode
                        showCopyAlert = true
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy to Clipboard")
                        }
                        .foregroundColor(.blue)
                    }
                }
                .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Invite User")
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Copied to Clipboard", isPresented: $showCopyAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The invite code has been copied to your clipboard.")
        }
    }
}
