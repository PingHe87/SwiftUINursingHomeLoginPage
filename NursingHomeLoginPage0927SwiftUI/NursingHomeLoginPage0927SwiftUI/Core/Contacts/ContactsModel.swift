//
//  ContactsModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//

import Foundation

struct Contact: Identifiable, Codable, Hashable, CustomStringConvertible {
    let id: String               // Unique identifier
    let fullName: String         // Full name of the contact
    let email: String            // Email address
    let profileImage: String?    // Optional: URL for profile image
    let role: Role               // Role of the user
    let isOnline: Bool?          // Optional: Whether the user is online
    var lastMessagePreview: String? // Optional: Last message preview
    var status: ContactStatus?   // Optional: Contact relationship status

    // Enum for user roles
    enum Role: String, Codable,CaseIterable {
        case staff = "staff"
        case resident = "resident"
        case relative = "relative"
        case unknown = "unknown"
    }

    // Enum for contact statuses
    enum ContactStatus: String, Codable {
        case friend        // Already a friend
        case pending       // Friend request sent, awaiting acceptance
        case requested     // Friend request received, awaiting user's response
        case notFriend     // Not a friend
    }

    // Readable description for the contact status
    var statusDescription: String {
        switch status {
        case .friend: return "Friend"
        case .pending: return "Pending Request"
        case .requested: return "Request Received"
        case .notFriend: return "Not a Friend"
        case .none: return "Unknown Status"
        }
    }

    // Readable description for the role
    var roleDescription: String {
        switch role {
        case .staff: return "Staff"
        case .resident: return "Resident"
        case .relative: return "Relative"
        case .unknown: return "Unknown Role"
        }
    }

    // Debug description for printing the object
    var description: String {
        return """
        Contact(
            id: \(id),
            fullName: \(fullName),
            email: \(email),
            role: \(roleDescription),
            isOnline: \(isOnline ?? false),
            lastMessagePreview: \(lastMessagePreview ?? "None"),
            status: \(statusDescription)
        )
        """
    }

    // Initializer
    init(
        id: String,
        fullName: String,
        email: String,
        profileImage: String? = nil,
        role: Role,
        isOnline: Bool? = false,
        lastMessagePreview: String? = nil,
        status: ContactStatus? = .notFriend
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.profileImage = profileImage
        self.role = role
        self.isOnline = isOnline
        self.lastMessagePreview = lastMessagePreview
        self.status = status
    }

    // Conformance to Hashable (to use in sets or as dictionary keys)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Equality check for Hashable
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}

