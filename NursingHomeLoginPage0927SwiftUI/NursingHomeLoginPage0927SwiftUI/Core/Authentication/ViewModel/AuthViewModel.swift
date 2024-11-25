//
//  AuthViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import SwiftUI

protocol AuthenticationFormProtocal {
    var formIsValid: Bool { get }
}

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    /// Sign in an existing user
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Update userSession
            self.userSession = result.user
            
            await fetchUser()
        } catch {
            print("Error signing in: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Create a new user and save to Firestore
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - firstName: User's first name
    ///   - middleName: User's middle name (optional)
    ///   - lastName: User's last name
    ///   - role: User's role (e.g., "staff", "resident", "relative")
    func createUser(withEmail email: String, password: String, firstName: String, middleName: String?, lastName: String, role: String) async throws {
        let db = Firestore.firestore()

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)

            let fullName = [firstName, middleName, lastName].compactMap { $0 }.joined(separator: " ")

            let user = User(
                id: result.user.uid,
                firstName: firstName,
                middleName: middleName,
                lastName: lastName,
                email: email,
                role: role,
                contacts: [],
                pendingRequests: []
            )

            try await db.collection("users").document(user.id).setData([
                "id": user.id,
                "firstName": firstName,
                "middleName": middleName ?? "",
                "lastName": lastName,
                "fullName": fullName,
                "email": email,
                "role": role,
                "contacts": [],
                "pendingRequests": []
            ])
            
            print("User created successfully: \(user)")
        } catch {
            print("Error creating user: \(error.localizedDescription)")
            throw error
        }
    }


    
    /// Sign out the current user
    func signOut() {
        do {
            // Try to sign out
            try Auth.auth().signOut()
            
            // Clear session data
            self.userSession = nil
            self.currentUser = nil
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    /// Fetch the current user's data from Firestore
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No logged-in user.")
            return
        }

        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            
            if let data = snapshot.data() {
                print("Fetched data: \(data)")  // Log raw Firestore data
                
                // Decode Firestore data on the current thread (background)
                let user = try snapshot.data(as: User.self)
                
                // Update @Published property on the main thread
                DispatchQueue.main.async {
                    self.currentUser = user
                    print("Decoded user: \(String(describing: self.currentUser))")
                }
            } else {
                print("No user document found for uid: \(uid)")
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }


    
    /// Change the current user's password
    /// - Parameter newPassword: New password
    func changePassword(to newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "UserNotLoggedIn", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        
        do {
            try await user.updatePassword(to: newPassword)
            print("Password changed successfully.")
        } catch {
            print("Error updating password: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Send a password reset email
    /// - Parameter email: User's email
    func forgotPassword(email: String) async throws {
        guard !email.isEmpty else {
            throw NSError(domain: "InvalidEmail", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email cannot be empty"])
        }
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("Password reset email sent successfully to \(email)")
        } catch {
            print("Error sending password reset email: \(error.localizedDescription)")
            throw error
        }
    }
}

