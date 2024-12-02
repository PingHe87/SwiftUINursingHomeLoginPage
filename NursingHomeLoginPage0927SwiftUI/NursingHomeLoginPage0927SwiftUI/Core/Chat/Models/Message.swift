//
//  Message.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/2/24.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let senderID: String
    let receiverID: String
    let text: String
    let timestamp: Date
    let isRead: Bool
}
