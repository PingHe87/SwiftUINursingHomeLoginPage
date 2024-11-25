//
//  Untitled.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import Foundation

struct Contact: Identifiable, Codable {
    let id: String
    let name: String // Full name
    let email: String
    let role: String // Role (staff, resident, relative)
}
