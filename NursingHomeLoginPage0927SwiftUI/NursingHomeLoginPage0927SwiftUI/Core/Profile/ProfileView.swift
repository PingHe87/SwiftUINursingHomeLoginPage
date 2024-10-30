//
//  ProfileView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import SwiftUI
import CoreLocation

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {  // Add NavigationView to enable navigation
            List {
                // User profile section
                Section {
                    HStack {
                        Text(authViewModel.currentUser?.initials ?? "")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authViewModel.currentUser?.fullname ?? "Unknown")
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .padding(.top, 4)
                            
                            Text(authViewModel.currentUser?.email ?? "No email")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }


                // Account section with Sign Out button
                Section("Account") {
                    Button {
                        // Call sign out function
                        authViewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                }
            }
          
            .navigationTitle("Profile")  // Set navigation title
        }
    }



}

#Preview {
    ProfileView()
}
