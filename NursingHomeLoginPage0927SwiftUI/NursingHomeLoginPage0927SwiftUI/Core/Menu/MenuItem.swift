//
//  MenuItem.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/4/24.
//

import Foundation

// Data model representing a menu item
struct MenuItem: Identifiable {
    let id: UUID = UUID()           // Unique identifier
    let name: String                // Name of the dish
    let description: String         // Description of the dish
    let imageUrl: String?           // URL of the dish image (optional)
    let nutritionInfo: String       // Nutritional information, e.g., "300 kcal"
    let dietaryTags: [String]       // Dietary tags, e.g., "V" for vegetarian, "GF" for gluten-free
    let allergens: [String]         // List of allergens, e.g., "Soy", "Nuts"
}
