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
                TextField("Search for a user...", text: $viewModel.searchText, onCommit: {
                    viewModel.searchUsers()
                })
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .overlay(
                    HStack {
                        Spacer()
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                                viewModel.searchResults = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 16)
                            }
                        }
                    }
                )
            }
            .padding(.top)
            
            if viewModel.isLoading {
                ProgressView("Searching...")
                    .padding()
            } else if viewModel.searchResults.isEmpty && !viewModel.searchText.isEmpty {
                VStack {
                    Image(systemName: "person.crop.circle.badge.xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("No users found")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.searchResults) { user in
                            FriendCard(user: user, onAddFriend: {
                                viewModel.sendFriendRequest(to: user.id)
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
