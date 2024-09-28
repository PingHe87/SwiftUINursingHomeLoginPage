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
    
    func signIn(withEmail email : String, password : String) async throws{
        print("Sign in ..")
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
    
    func signOut(){
        
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async{
        
    }
}
