//
//  ContactsModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//

import Foundation

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let phoneNumber: String
    let profileImage: String  
    let lastMessagePreview: String  // Add this property for the last message preview
    
    // Mock data for testing
    static let mockContacts = [
        Contact(name: "Alice Johnson", phoneNumber: "123-456-7890", profileImage: "profile1", lastMessagePreview: "Looking forward to seeing you!"),
        Contact(name: "Bob Smith", phoneNumber: "987-654-3210", profileImage: "profile2", lastMessagePreview: "Can we reschedule our meeting?"),
        Contact(name: "Cathy Brown", phoneNumber: "555-123-4567", profileImage: "profile3", lastMessagePreview: "Thank you for your help!")
    ]
}
