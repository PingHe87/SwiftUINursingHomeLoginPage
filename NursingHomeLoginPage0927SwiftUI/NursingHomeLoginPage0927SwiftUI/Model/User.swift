//
//  User.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import Foundation

struct User: Identifiable, Codable {
    
    let id: String
    let firstName: String
    var middleName: String?  = nil// Optional middle name
    let lastName: String
    let email: String
    let role: String // User's role (e.g., staff, resident, relative, admin)
    
    // New fields
    var contacts: [String] = [] // IDs of user's contacts
    var pendingRequests: [String] = [] // IDs of pending friend requests

    // Combine first, middle, and last names into a full name
    var fullName: String {
        [firstName, middleName, lastName].compactMap { $0 }.joined(separator: " ")
    }

    // Generate initials from the full name
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .abbreviated
        
        let nameComponents = PersonNameComponents(
            givenName: firstName,
            middleName: middleName,
            familyName: lastName
        )
        
        return formatter.string(from: nameComponents)
    }
}

extension User {
    // Enum for predefined roles
    enum Role: String, Codable {
        case staff = "staff"
        case resident = "resident"
        case relative = "relative"
        case admin = "admin" // Added admin role
    }

    // Example MOCK_USER for testing
    static var MOCK_USER = User(
        id: UUID().uuidString,
        firstName: "Test",
        middleName: "Middle",
        lastName: "Lastname",
        email: "test@gmail.com",
        role: Role.staff.rawValue, // Default mock role
        contacts: ["mockContactID1", "mockContactID2"], // Mock contacts
        pendingRequests: ["mockRequestID1"] // Mock pending requests
    )
}
