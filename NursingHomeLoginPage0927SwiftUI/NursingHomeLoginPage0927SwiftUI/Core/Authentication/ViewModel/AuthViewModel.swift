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

class AuthViewModel : ObservableObject {
    
    @Published var userSession : FirebaseAuth.User?
    @Published var currentUser : User?
    
    init(){
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // update  userSession
            self.userSession = result.user
            
            //await fetchUser()  // 假设你有实现这个函数来从 Firestore 获取用户数据
            
            print("User signed in successfully.")
        } catch {
            // catch error
            print("Error signing in: \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email : String, password : String, fullname : String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodeUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodeUser)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signOut() {
        do {
            //try sign out
            try Auth.auth().signOut()
            
            // set nil after success
            self.userSession = nil
            self.currentUser = nil
            print("User signed out successfully.")
        } catch {
            // error control
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async{
        
    }
}
