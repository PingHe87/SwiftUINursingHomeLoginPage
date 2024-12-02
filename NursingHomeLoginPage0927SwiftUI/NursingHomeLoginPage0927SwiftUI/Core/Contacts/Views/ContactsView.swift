//
//  ContactsView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactsView: View {
    @StateObject private var viewModel = ContactsViewModel() // View model for contacts
    @State private var isRelativeExpanded = true             // Expanded state for Relative group
    @State private var isStaffExpanded = true                // Expanded state for Staff group
    @State private var searchText: String = ""               // Search text
    @State private var isShowingPendingRequests = false      // Control pending requests view
    @State private var isShowingAddFriendView = false        // Control add friend view

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Top buttons: Notification and Add Friend
                HStack {
                    Button(action: {
                        isShowingPendingRequests = true
                    }) {
                        HStack {
                            Image(systemName: "bell")
                                .font(.title2)
                            if viewModel.pendingRequestsCount > 0 {
                                Text("\(viewModel.pendingRequestsCount)")
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingPendingRequests) {
                        PendingRequestsView()
                    }

                    Spacer()

                    Button(action: {
                        isShowingAddFriendView = true
                    }) {
                        Image(systemName: "person.badge.plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $isShowingAddFriendView) {
                        AddFriendView() // Navigate to AddFriendView
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search contacts...", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: searchText) { _ in
                            viewModel.filterContacts(by: searchText)
                        }
                }
                .padding(.horizontal)

                // Contacts list
                List {
                    // Relative group with toggle
                    if let relatives = viewModel.filteredContacts["Relative"], !relatives.isEmpty {
                        Section {
                            if isRelativeExpanded {
                                ForEach(relatives) { contact in
                                    ContactCard(contact: contact)
                                        .padding(.vertical, 5)
                                }
                            }
                        } header: {
                            GroupHeader(title: "RELATIVE", isExpanded: $isRelativeExpanded)
                        }
                    }

                    // Staff group with toggle
                    if let staff = viewModel.filteredContacts["Staff"], !staff.isEmpty {
                        Section {
                            if isStaffExpanded {
                                ForEach(staff) { contact in
                                    ContactCard(contact: contact)
                                        .padding(.vertical, 5)
                                }
                            }
                        } header: {
                            GroupHeader(title: "STAFF", isExpanded: $isStaffExpanded)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarHidden(true) // Hide navigation bar
        }
    }
}

// Custom group header with toggle functionality
struct GroupHeader: View {
    let title: String
    @Binding var isExpanded: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .foregroundColor(.gray)
                    .imageScale(.medium)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 5)
        .background(Color(.systemGroupedBackground))
    }
}

