//
//  AddFriendView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct AddFriendView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @EnvironmentObject var contactsViewModel: ContactsViewModel

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search users")
                List {
                    ForEach(contactsViewModel.contacts, id: \.id) { contact in
                        HStack {
                            Text(contact.fullName)
                            Spacer()
                            if contact.status == .notFriend {
                                Button(action: {
                                    Task {
                                        do {
                                            try await contactsViewModel.sendFriendRequest(currentUserId: "yourUserID", friendId: contact.id)
                                        } catch {
                                            print("Error sending friend request: \(error)")
                                        }
                                    }
                                }) {
                                    Text("Add Friend")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Friend")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                Task {
                    do {
                        try await contactsViewModel.searchUsers(byName: searchText)
                    } catch {
                        print("Error searching for users: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    @EnvironmentObject var contactsViewModel: ContactsViewModel  // 使用环境对象

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)

                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .onSubmit {
                Task {
                    try? await contactsViewModel.searchUsers(byName: text)
                }
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
    }
}
