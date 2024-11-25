//
//  ContactsView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//

import SwiftUI

struct ContactsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var contactsViewModel = ContactsViewModel()
    @State private var showingAddFriendView = false

    var body: some View {
        NavigationView {
            VStack {
                ContactsListView()
                    .environmentObject(contactsViewModel)

                Button(action: {
                    showingAddFriendView = true
                }) {
                    Label("Add Friend", systemImage: "plus.circle")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .onAppear {
                // Fetch contacts, potentially from AuthViewModel's user information
            }
            .sheet(isPresented: $showingAddFriendView) {
                AddFriendView().environmentObject(contactsViewModel)
            }
        }
    }
}
