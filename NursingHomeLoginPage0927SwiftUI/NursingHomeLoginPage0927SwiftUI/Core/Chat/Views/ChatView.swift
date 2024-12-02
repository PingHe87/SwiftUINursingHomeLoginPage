//
//  ChatView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ChatView: View {
    let contact: Contact // Contact with whom the chat is happening
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            // Message list
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.senderID == viewModel.currentUserID {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue.opacity(0.7))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            // Input field and send button
            HStack {
                TextField("Type a message...", text: $viewModel.newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    viewModel.sendMessage(to: contact.id)
                }) {
                    Text("Send")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(viewModel.newMessage.isEmpty)
            }
            .padding()
        }
        .navigationTitle(contact.name)
        .onAppear {
            viewModel.loadMessages(with: contact.id)
        }
    }
}

