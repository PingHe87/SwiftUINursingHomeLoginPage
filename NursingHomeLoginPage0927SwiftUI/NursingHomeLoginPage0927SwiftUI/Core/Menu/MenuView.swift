//
//  MenuView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/4/24.
//

import SwiftUI

// Main view to display the menu
struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.menuItems) { item in
                VStack(alignment: .leading, spacing: 8) {
                    // Display image if the URL is available, otherwise use a placeholder
                    if let imageUrl = item.imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView() // Loading indicator
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150) // Adjust height as needed
                                    .clipped()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .foregroundColor(.gray)
                            @unknown default:
                                Image(systemName: "exclamationmark.triangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .foregroundColor(.red)
                            }
                        }
                        .cornerRadius(10)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                    }
                    
                    Text(item.name)
                        .font(.headline)
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        if !item.dietaryTags.isEmpty {
                            Text("Tags: \(item.dietaryTags.joined(separator: ", "))")
                                .font(.footnote)
                                .foregroundColor(.green)
                        }
                        Spacer()
                        Text(item.nutritionInfo)
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    
                    if !item.allergens.isEmpty {
                        Text("Allergens: \(item.allergens.joined(separator: ", "))")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("Menu")
        }
    }
}
