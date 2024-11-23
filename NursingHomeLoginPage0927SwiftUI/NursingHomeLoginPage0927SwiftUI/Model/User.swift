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
    let middleName: String? // Optional middle name
    let lastName: String
    let email: String
    let role: String // User's role (e.g., staff, resident, relative)

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
    }

    // Example MOCK_USER for testing
    static var MOCK_USER = User(
        id: UUID().uuidString,
        firstName: "Test",
        middleName: "Middle",
        lastName: "Lastname",
        email: "test@gmail.com",
        role: Role.staff.rawValue // Default mock role
    )
}

