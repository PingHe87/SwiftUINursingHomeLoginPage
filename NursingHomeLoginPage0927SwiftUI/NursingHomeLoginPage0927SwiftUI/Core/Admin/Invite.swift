//
//  Invite.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/14/24.
//

struct Invite: Identifiable, Codable {
    var id: String
    var code: String
    var isUsed: Bool
    var usedBy: String? // Optional
}
