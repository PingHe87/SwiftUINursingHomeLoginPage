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
                        Button("Accept") {
                            Task {
                                await viewModel.acceptRequest(from: user.id)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)

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
        .navigationTitle("Pending Requests")
    }
}
