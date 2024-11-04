//
//  ActivityModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/4/24.
//

import Foundation

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let location : String
    let description: String
}
