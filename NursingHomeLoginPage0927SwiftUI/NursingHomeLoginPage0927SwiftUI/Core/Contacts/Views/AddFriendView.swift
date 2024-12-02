//
//  AddFriendView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct AddFriendView: View {
    @StateObject private var viewModel = AddFriendViewModel()

    var body: some View {
        VStack {
            HStack {
                TextField("Search for a user...", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onSubmit {
                        Task {
                            await viewModel.searchUsers()
                        }
                    }
            }
            .padding(.top)

            if viewModel.isLoading {
                ProgressView("Searching...")
                    .padding()
            } else if viewModel.searchResults.isEmpty && !viewModel.searchText.isEmpty {
                Text("No users found.")
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.searchResults) { user in
                            FriendCard(user: user, onAddFriend: {
                                Task {
                                    await viewModel.sendFriendRequest(to: user.id)
                                }
                            })
                        }
                    }
                    .padding()
                }
            }

            Spacer()
        }
        .navigationTitle("Add Friend")
        .alert(isPresented: $viewModel.requestSent) {
            Alert(
                title: Text("Friend Request Sent"),
                message: Text("Your friend request has been sent successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
