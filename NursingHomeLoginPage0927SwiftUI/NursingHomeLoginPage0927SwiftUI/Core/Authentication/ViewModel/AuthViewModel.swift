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
    
    @Published var userSession: FirebaseAuth.User? // Currently authenticated Firebase user session
    @Published var currentUser: User? // Current user data fetched from Firestore
    
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
            
            // Fetch user data from Firestore
            await fetchUser()
        } catch {
            print("Error signing in: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Sign out the current user
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    /// Send a password reset email
    /// - Parameter email: The email address of the user
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
    
    /// Fetch the current user's data from Firestore
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No logged-in user.")
            return
        }

        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            
            if let data = snapshot.data() {
                print("Fetched data: \(data)") // Log raw Firestore data
                
                // Decode Firestore data on the current thread (background)
                let user = try snapshot.data(as: User.self)
                
                // Update @Published property on the main thread
                DispatchQueue.main.async {
                    self.currentUser = user
                }
            } else {
                print("No user document found for uid: \(uid)")
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }
    
    /// Save user data to Firestore
    /// - Parameters:
    ///   - id: User ID
    ///   - email: User's email
    ///   - firstName: User's first name
    ///   - middleName: User's middle name (optional)
    ///   - lastName: User's last name
    ///   - role: User's role
    private func saveUserToFirestore(id: String, email: String, firstName: String, middleName: String?, lastName: String, role: String) async throws {
        let db = Firestore.firestore()
        
        let fullName = [firstName, middleName, lastName].compactMap { $0 }.joined(separator: " ")
        
        // Save the user data to Firestore
        try await db.collection("users").document(id).setData([
            "id": id,
            "email": email,
            "firstName": firstName,
            "middleName": middleName ?? "",
            "lastName": lastName,
            "fullName": fullName,
            "role": role,
            "contacts": [],
            "pendingRequests": []
        ])
    }
    
    /// Create a new user for self-registration
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    ///   - firstName: User's first name
    ///   - middleName: User's middle name (optional)
    ///   - lastName: User's last name
    ///   - role: User's role
    func createUser(withEmail email: String, password: String, firstName: String, middleName: String? = nil, lastName: String, role: String) async throws {
        do {
            // Create user in Firebase Authentication
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Save user to Firestore
            try await saveUserToFirestore(id: result.user.uid, email: email, firstName: firstName, middleName: middleName, lastName: lastName, role: role)
            
            print("User created successfully with self-registration.")
        } catch {
            print("Error creating user: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Create a new user as admin
    /// - Parameters:
    ///   - email: New user's email
    ///   - firstName: New user's first name
    ///   - lastName: New user's last name
    ///   - role: New user's role
    /// - Returns: A unique invite code for the new user
    func createUserAsAdmin(email: String, firstName: String, lastName: String, role: String) async throws -> String {
        let db = Firestore.firestore()
        let emailSender = EmailSender() 
        
        do {
            let inviteCode = UUID().uuidString // Generate a unique invite code
            let userId = UUID().uuidString // Locally generated user ID
            
            
            try await saveUserToFirestore(id: userId, email: email, firstName: firstName, middleName: nil, lastName: lastName, role: role)
            
          
            try await db.collection("users").document(userId).updateData([
                "inviteCode": inviteCode,
                "isRegistered": false
            ])
            
          
            emailSender.sendInvitationEmail(to: email, inviteCode: inviteCode, inviterName: "Admin") { success in
                if success {
                    print("Invitation email sent successfully!")
                } else {
                    print("Failed to send invitation email.")
                }
            }
            
            return inviteCode
        } catch {
            print("Error creating user as admin: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Validate the provided invite code
    /// - Parameter code: The invite code to validate
    func validateInviteCode(_ code: String) async throws {
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection("invites")
                .whereField("inviteCode", isEqualTo: code)
                .getDocuments()
            
            guard let document = snapshot.documents.first else {
                throw NSError(domain: "InvalidInviteCode", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invite code is invalid."])
            }
            
            // Check if the invite code has already been used
            let data = document.data()
            if let isUsed = data["isUsed"] as? Bool, isUsed == true {
                throw NSError(domain: "InviteCodeUsed", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invite code has already been used."])
            }
            
            // Mark the invite code as used
            try await db.collection("invites").document(document.documentID).updateData([
                "isUsed": true
            ])
            
            print("Invite code validated and marked as used.")
        } catch {
            print("Error validating invite code: \(error.localizedDescription)")
            throw error
        }
    }
    
    func generateInviteCode(for email: String, role: String) async throws -> String {
        let db = Firestore.firestore()
        
        do {
            // Generate unique invite code
            let inviteCode = UUID().uuidString
            
            // Save invite code to Firestore
            let inviteId = UUID().uuidString
            try await db.collection("invites").document(inviteId).setData([
                "id": inviteId,
                "email": email,
                "inviteCode": inviteCode,
                "role": role, // Include the role
                "invitedBy": currentUser?.id ?? "", // Link to the inviter
                "createdAt": Timestamp(),
                "isUsed": false // Track if the invite code has been used
            ])
            
            print("Invite code generated: \(inviteCode)")
            return inviteCode
        } catch {
            print("Error generating invite code: \(error.localizedDescription)")
            throw error
        }
    }

    
    func changePassword(to newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
        }
        
        do {
            try await user.updatePassword(to: newPassword)
            print("Password changed successfully.")
        } catch {
            print("Error updating password: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Validate invite code and email match
        /// - Parameters:
        ///   - code: The invite code
        ///   - email: The email address to validate
        /// - Throws: An error if validation fails
        func validateInviteCodeWithEmail(_ code: String, email: String) async throws {
            let db = Firestore.firestore()
            
            do {
                // Query the invites collection to find the invite code and email
                let snapshot = try await db.collection("invites")
                    .whereField("inviteCode", isEqualTo: code)
                    .whereField("email", isEqualTo: email)
                    .getDocuments()
                
                guard let document = snapshot.documents.first else {
                    throw NSError(domain: "InvalidInviteCode", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid invite code or email."])
                }
                
                // Check if the invite has already been used
                let data = document.data()
                if let isUsed = data["isUsed"] as? Bool, isUsed == true {
                    throw NSError(domain: "InviteCodeUsed", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invite code has already been used."])
                }
                
                // Mark the invite as used
                try await db.collection("invites").document(document.documentID).updateData([
                    "isUsed": true
                ])
                
                print("Invite code and email validated successfully.")
            } catch {
                print("Error validating invite code with email: \(error.localizedDescription)")
                throw error
            }
        }


}
