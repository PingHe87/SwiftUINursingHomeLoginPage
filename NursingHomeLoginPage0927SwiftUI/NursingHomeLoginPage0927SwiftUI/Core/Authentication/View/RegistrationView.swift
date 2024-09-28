//
//  RegistrationView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmpassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        VStack{
            
            //image
            Image("splash")
                .resizable()
                .scaledToFill()
                .frame(width: 100,height: 120)
                .padding(.vertical, 32)
            
            //form fields
            VStack(spacing: 24){
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter Your Full Name")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecuredField: true)
                
                InputView(text: $confirmpassword,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
                          isSecuredField: true)
            }
            .padding(.horizontal)
            .padding(.top,12)
            
            //sign up button
            Button{
                Task{
                    try await viewModel.createUser(withEmail : email,
                                                   password : password,
                                                   fullname : fullname)
                }
            }label : {
                HStack{
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top,24)
            
            Spacer()
            
            //back to sign in
            Button{
                dismiss()
            }label: {
                HStack{
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 17))
            }
        }
    }
}

#Preview {
    RegistrationView()
}
