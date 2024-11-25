//
//  RegistrationView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var firstName = ""
    @State private var middleName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var selectedRole = "resident" // Default role
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    let roles = ["staff", "resident", "relative"] // Available roles
    
    var body: some View {
        ScrollView { // Wrap everything in ScrollView
            VStack {
                
                // Image
                Image("splash")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                // Form fields
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    InputView(text: $firstName,
                              title: "First Name",
                              placeholder: "Enter your first name")
                    
                    InputView(text: $middleName,
                              title: "Middle Name (optional)",
                              placeholder: "Enter your middle name")
                    
                    InputView(text: $lastName,
                              title: "Last Name",
                              placeholder: "Enter your last name")
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecuredField: true)
                    .textContentType(.none) // Disable autofill
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm your password",
                                  isSecuredField: true)
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    
                    // Role picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Role")
                            .font(.headline)
                        Picker("Role", selection: $selectedRole) {
                            ForEach(roles, id: \.self) { role in
                                Text(role.capitalized)
                                    .tag(role)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.top, 16)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Sign Up button
                Button {
                    Task {
                        try await viewModel.createUser(
                            withEmail: email,
                            password: password,
                            firstName: firstName,
                            middleName: middleName.isEmpty ? nil : middleName, // Pass nil if empty
                            lastName: lastName,
                            role: selectedRole // Pass the selected role
                        )
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                // Back to Sign In
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 17))
                }
            }
            .padding() // Add padding inside ScrollView
        }
    }
}

// MARK: - AuthenticationFormProtocal

extension RegistrationView: AuthenticationFormProtocal {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !firstName.isEmpty
        && !lastName.isEmpty
    }
}

#Preview {
    RegistrationView()
}
