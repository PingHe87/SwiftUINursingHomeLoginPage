//  HomepageView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/4/24.
//

import SwiftUI

struct HomepageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var activityViewModel = ActivityViewModel()
    @State private var showingAddActivityView = false  // State to show the add activity view

    var body: some View {
        ZStack {
           
//            LinearGradient(
//                gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .edgesIgnoringSafeArea(.top)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting message for the user
                    Text("Hello, \(authViewModel.currentUser?.fullname ?? "User")!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    // Header for today's activities with an "Add" button
                    HStack {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text("Today's Activities")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Spacer()  // Pushes the "Add" button to the right

                        // "Add" button to navigate to AddActivityView
                        Button(action: {
                            showingAddActivityView = true  // Show the AddActivityView
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 5)

                    // Activity card views
                    ForEach(activityViewModel.activities) { activity in
                        ActivityCardView(activity: activity)
                    }

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
                .padding(.horizontal)  // Correct context for padding
                .navigationTitle("Home")
                .sheet(isPresented: $showingAddActivityView) {
                    AddActivityView(activityViewModel: activityViewModel)  // Pass the view model
                }
            }
        }
    }
}
