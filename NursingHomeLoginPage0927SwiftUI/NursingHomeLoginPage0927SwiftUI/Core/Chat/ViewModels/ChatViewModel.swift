//
//  ChatViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [] // Messages in the chat
    @Published var newMessage: String = "" // Input for new message
    let currentUserID = "currentUserID" // Replace with actual user ID
    private let db = Firestore.firestore()

    // Load chat messages
    func loadMessages(with contactID: String) {
        db.collection("chats")
            .document(currentUserID + "_" + contactID) // Example composite key
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                if let documents = snapshot?.documents {
                    self?.messages = documents.compactMap { document in
                        try? document.data(as: Message.self)
                    }
                }
            }
    }

    // Send a new message
    func sendMessage(to contactID: String) {
        let message = Message(
            id: UUID().uuidString,
            senderID: currentUserID,
            receiverID: contactID,
            text: newMessage,
            timestamp: Date(),
            isRead: false
        )
        do {
            try db.collection("chats")
                .document(currentUserID + "_" + contactID)
                .collection("messages")
                .document(message.id)
                .setData(from: message)
            newMessage = "" // Clear input field
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}

