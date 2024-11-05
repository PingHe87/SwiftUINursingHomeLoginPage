//
//  ChatView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//

import SwiftUI

struct ChatView: View {
    let contact: Contact
    @State private var messages: [ChatMessage] = ChatMessage.mockMessages
    @State private var newMessage = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isSentByUser {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .foregroundColor(.black)
                                    .cornerRadius(15)
                                    .frame(maxWidth: 250, alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            
            // Input field for new message
            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .navigationTitle(contact.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Function to send a new message
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let newChatMessage = ChatMessage(id: UUID(), text: newMessage, isSentByUser: true)
        messages.append(newChatMessage)
        newMessage = ""
        
        // Mock response after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let responseMessage = ChatMessage(id: UUID(), text: "This is an automated response.", isSentByUser: false)
            messages.append(responseMessage)
        }
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isSentByUser: Bool
    
    static let mockMessages: [ChatMessage] = [
        ChatMessage(id: UUID(), text: "Hello!", isSentByUser: false),
        ChatMessage(id: UUID(), text: "Hi, how are you?", isSentByUser: true),
        ChatMessage(id: UUID(), text: "I'm doing well, thanks!", isSentByUser: false)
    ]
}
