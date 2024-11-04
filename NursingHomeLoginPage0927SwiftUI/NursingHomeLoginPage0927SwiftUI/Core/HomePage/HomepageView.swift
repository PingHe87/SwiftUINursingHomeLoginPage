//
//  HomepageView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/4/24.
//

import SwiftUI

struct HomepageView: View {
    // Replace with actual user data or state
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var activityViewModel = ActivityViewModel()
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                // Greeting message
                Text("Hello, \(authViewModel.currentUser?.fullname ?? "User")!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Activity reminder section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue) // Set the icon color to blue
                                .font(.title2) // Set the size of the icon
                            
                            Text("Today's Activities")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding(.bottom, 5)
                    
                    if activityViewModel.activities.isEmpty {
                        Text("No activities scheduled for today.")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(activityViewModel.activities) { activity in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(activity.title)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)  // Left-align the text
                                // Time with icon
                                HStack(spacing: 5) {
                                    Image(systemName: "clock")  // Time icon
                                        .foregroundColor(.blue)
                                    Text("\(activity.time)")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)  // Left-align the text
                                }
                                // Location with icon
                                HStack(spacing: 5) {
                                    Image(systemName: "mappin")  // Location icon
                                        .foregroundColor(.blue)
                                    Text("\(activity.location)")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)  // Left-align the text
                                }
                                
                                Text(activity.description)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .leading)  // Left-align the text
                            }
                            .padding()
                            .frame(maxWidth: .infinity)  // Ensures all cards have the same width
                            .background(Color.white)
                            .cornerRadius(10)  // Rounded corners
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            .padding(.vertical, 5)  // Adds space between cards
                        }
                    }
                }
                .padding(.horizontal)  // Overall padding for activities section
                
                
                // Emergency and contact buttons
                VStack(spacing: 15) {
                    Button(action: {
                        // Action for emergency call
                        print("Emergency call tapped")
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.red)
                            Text("Call Emergency")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action to contact nurse
                        print("Contact nurse tapped")
                    }) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.blue)
                            Text("Contact Nurse")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action to get help
                        print("Get help tapped")
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Get Help")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                
                Spacer()  // Pushes content to the top of the screen
            }
            .padding(.horizontal)
            .navigationTitle("Home")
        }
        
    }
}

#Preview {
    HomepageView()
        .environmentObject(AuthViewModel())
}
