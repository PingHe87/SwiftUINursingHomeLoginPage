//
//  ContactDetailView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    @State private var newTag: String = "" // Tag input field
    @StateObject private var viewModel = ContactsViewModel() // ViewModel for handling tags

    var body: some View {
        VStack(spacing: 20) {
            // Contact Basic Information
            Text(contact.name)
                .font(.largeTitle)
                .bold()
            
            Text(contact.email)
                .font(.body)
                .foregroundColor(.gray)
            
            Text("Role: \(contact.role.capitalized)")
                .font(.headline)
            
            // Tag Management Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Tags:")
                    .font(.headline)
                
                // Input Field for Adding a New Tag
                HStack {
                    TextField("Enter a tag", text: $newTag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                    
                    Button(action: {
                        guard !newTag.isEmpty else { return }
                        Task {
                            await viewModel.addTag(to: contact.id, tag: newTag)
                            newTag = "" // Clear the input field
                        }
                    }) {
                        Text("Add")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                
                // Display Existing Tags
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(contact.tags, id: \.self) { tag in
                            HStack {
                                Text(tag)
                                    .padding(5)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(5)
                                
                                // Button to Remove a Tag
                                Button(action: {
                                    Task {
                                        await viewModel.removeTag(from: contact.id, tag: tag)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Contact Details")
    }
}

