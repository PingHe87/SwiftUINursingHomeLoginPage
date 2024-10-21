//
//  ChangePasswordView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by Travis Peck on 10/21/24.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmationPassword: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        VStack(spacing: 16){
            Text("Change Password")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            SecureField("Current Password", text: $currentPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
            SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm New Password", text: $confirmationPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
                
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
            }
            
            Button(action: {
                // Validate input first
                if newPassword.isEmpty || confirmationPassword.isEmpty || currentPassword.isEmpty {
                    errorMessage = "All fields are required."
                    return
                }
                
                if newPassword != confirmationPassword {
                    errorMessage = "New passwords do not match."
                    return
                }

                // Reset previous messages
                errorMessage = nil
                successMessage = nil

                // Call the change password function asynchronously
                Task {
                    do {
                        try await viewModel.changePassword(to: newPassword)
                        successMessage = "Password changed successfully!"
                    } catch {
                        errorMessage = "Failed to change password: \(error.localizedDescription)"
                    }
                }
            }) {
                Text("Change Password")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ChangePasswordView()
}
