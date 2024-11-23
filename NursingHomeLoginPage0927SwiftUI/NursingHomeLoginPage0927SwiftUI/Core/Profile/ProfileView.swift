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
                        // Circle with initials
                        Text(authViewModel.currentUser?.initials ?? "U")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            // Full name
                            Text(authViewModel.currentUser?.fullName ?? "Unknown User")
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .padding(.top, 4)
                            
                            // Email address
                            Text(authViewModel.currentUser?.email ?? "No email available")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Account section with Sign Out button
                Section("Account") {
                    Button {
                        authViewModel.signOut()  // Call sign out function
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}

