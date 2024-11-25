//
//  ContactsListView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactsListView: View {
    @EnvironmentObject var contactsViewModel: ContactsViewModel

    var body: some View {
        ScrollView {
            if contactsViewModel.contacts.isEmpty {
                Text("No contacts found.")
                   // .foregroundColor(.gray)
                    .padding()
            } else {
                VStack {
                    ForEach(Contact.Role.allCases, id: \.self) { role in
                        DisclosureGroup {
                            ForEach(contactsViewModel.groupedContacts[role] ?? [], id: \.id) { contact in
                                NavigationLink(destination: ChatView(contact: contact)) {
                                    ContactCardView(contact: contact)
                                }
                            }
                        } label: {
                            Text(role.rawValue.capitalized)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 1)
                    }
                }
            }
        }
    }
}

