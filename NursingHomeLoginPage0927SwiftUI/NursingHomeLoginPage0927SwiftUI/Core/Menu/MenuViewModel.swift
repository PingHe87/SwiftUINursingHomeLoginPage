//
//  MenuViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/4/24.
//

import Foundation

// ViewModel to manage and provide menu data
class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []  // List of menu items to be displayed

    init() {
        loadMenuData()
    }

    // Function to load menu data (could be extended to fetch from a server)
    func loadMenuData() {
        self.menuItems = sampleMenuItems  // Load sample data
    }
}
