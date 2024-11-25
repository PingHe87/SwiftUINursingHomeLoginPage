//
//  ConstactsView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//
import SwiftUI

struct ContactsView: View {
    @StateObject private var viewModel = ContactsViewModel()
    @State private var isAddingFriend = false
    
    var body: some View {
        NavigationView {
            VStack {
               
                List {
                    ForEach(viewModel.groupedContacts.keys.sorted(), id: \.self) { group in
                        Section(header: Text(group)) {
                            ForEach(viewModel.groupedContacts[group] ?? []) { contact in
                                NavigationLink(destination: ContactDetailView(contact: contact)) {
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
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Contacts")
            .navigationBarItems(trailing: Button(action: {
                isAddingFriend = true
            }) {
                Image(systemName: "person.badge.plus")
                    .font(.title2)
            })
            .sheet(isPresented: $isAddingFriend) {
                AddFriendView()
            }
        }
    }
}
