//
//  ContactsView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactsView: View {
    @StateObject private var viewModel = ContactsViewModel()
    @State private var isShowingPendingRequests = false // Control Pending Requests view

    var body: some View {
        NavigationView {
            List {
                // Loop through grouped contacts by category
                ForEach(viewModel.groupedContacts.keys.sorted(), id: \.self) { group in
                    Section(header: HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.blue)
                            .font(.title3)
                        Text(group)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                    }) {
                        // Display each contact with navigation to ChatView
                        ForEach(viewModel.groupedContacts[group] ?? []) { contact in
                            NavigationLink(destination: ChatView(contact: contact)) {
                                HStack(spacing: 15) {
                                    // Profile image
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)

                                    // Contact details
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(contact.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        Text(contact.email)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    // Role tag
                                    Text(contact.role.capitalized)
                                        .font(.caption)
                                        .padding(5)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(5)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Contacts")
            .navigationBarItems(
                // Leading button for pending requests
                leading: Button(action: {
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
                },
                // Trailing button for adding new friends
                trailing: Button(action: {
                    // Add Friend Button Action
                }) {
                    Image(systemName: "person.badge.plus")
                        .font(.title2)
                }
            )
        }
    }
}
