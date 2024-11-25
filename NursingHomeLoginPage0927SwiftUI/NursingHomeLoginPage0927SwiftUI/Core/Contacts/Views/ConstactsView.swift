//
//  ConstactsView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//
import SwiftUI

struct ContactsView: View {
    @StateObject private var viewModel = ContactsViewModel()
    @State private var isShowingPendingRequests = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.groupedContacts.keys.sorted(), id: \.self) { group in
                        Section(header: Text(group)) {
                            ForEach(viewModel.groupedContacts[group] ?? []) { contact in
                                HStack {
                                    Text(contact.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(contact.role.capitalized)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Contacts")
            .navigationBarItems(
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
