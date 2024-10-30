//
//  ForgotPasswordView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by Travis Peck on 10/30/24.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.headline)
                .padding(.top, 64)
            
            InputView(text: $email, title: "Email Address", placeholder: "Enter your email")
                .padding(.horizontal)
                .padding(.top, 32)
            
            Button {
                Task {
                    do {
                       try await auth.forgotPassword(email: email)
                    } catch {
                        print("Error resetting password: \(error.localizedDescription)")
                    }
                }
            } label: {
                    Text ("Send Reset Link")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        .background(Color.blue)
                        .cornerRadius(16)
            }
        }
        .padding()
    }
}
