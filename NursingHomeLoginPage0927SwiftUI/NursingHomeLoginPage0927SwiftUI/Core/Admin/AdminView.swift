//
//  AdminView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/14/24.
//

import SwiftUI

struct AdminView: View {
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedRole = "resident"
    @State private var inviteCode = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let roles = ["staff", "resident", "relative"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Admin Panel")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // Input form for user information
                VStack(spacing: 16) {
                    InputView(text: $email,
                              title: "Email",
                              placeholder: "Enter email address")
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    InputView(text: $firstName,
                              title: "First Name",
                              placeholder: "Enter first name")

                    InputView(text: $lastName,
                              title: "Last Name",
                              placeholder: "Enter last name")

                    // Role selector
                    VStack(alignment: .leading) {
                        Text("Role")
                            .font(.headline)
                        Picker("Select Role", selection: $selectedRole) {
                            ForEach(roles, id: \.self) { role in
                                Text(role.capitalized)
                                    .tag(role)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Button to create user
                Button(action: {
                    Task {
                        do {
                            inviteCode = try await authViewModel.createUserAsAdmin(
                                email: email,
                                firstName: firstName,
                                lastName: lastName,
                                role: selectedRole
                            )
                            print("User created with invite code: \(inviteCode)")
                        } catch {
                            print("Error creating user: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Create User")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .disabled(email.isEmpty || firstName.isEmpty || lastName.isEmpty) // Form validation
                .opacity(email.isEmpty || firstName.isEmpty || lastName.isEmpty ? 0.5 : 1.0)

                // Display the generated invite code
                if !inviteCode.isEmpty {
                    Text("Invite Code: \(inviteCode)")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Admin Panel")
        }
    }
}

