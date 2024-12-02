//
//  PendingRequestsView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct PendingRequestsView: View {
    @StateObject private var viewModel = PendingRequestsViewModel()

    var body: some View {
        VStack {
            if viewModel.pendingRequests.isEmpty {
                // Display message when no pending requests
                Text("No pending friend requests.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // List of pending requests
                List {
                    ForEach(viewModel.pendingRequests) { user in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.fullName)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            HStack {
                                // Accept button
                                Button("Accept") {
                                    Task {
                                        await viewModel.acceptRequest(from: user.id)
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)

                                // Reject button
                                Button("Reject") {
                                    Task {
                                        await viewModel.rejectRequest(from: user.id)
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.red)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Pending Requests") // Set the navigation title
    }
}

