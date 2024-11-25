//
//  ConstactsView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactsView: View {
    @StateObject private var viewModel = ContactsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {

                TextField("Search contacts...", text: $viewModel.searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                List {
                    ForEach(viewModel.groupedContacts.keys.sorted(), id: \.self) { group in
                        Section(header: Text(group)) {
                            DisclosureGroup(group) {
                                ForEach(viewModel.groupedContacts[group] ?? []) { contact in
                                    NavigationLink(destination: ContactDetailView(contact: contact)) {
                                        HStack {
                                            Text(contact.name)
                                                .font(.headline)
                                            Spacer()
                                            Text(contact.email)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Contacts")
        }
    }
}
