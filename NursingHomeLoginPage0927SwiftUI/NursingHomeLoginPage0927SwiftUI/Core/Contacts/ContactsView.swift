//
//  ContactsView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//


import SwiftUI

struct ContactsView: View {
    @State private var contacts = Contact.mockContacts
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(contacts) { contact in
                        NavigationLink(destination: ChatView(contact: contact)) {
                            ContactCardView(contact: contact)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 10)
                .navigationTitle("Contacts")
            }
        }
    }
}

struct ContactCardView: View {
    let contact: Contact
    
    var body: some View {
        HStack {
            // Use a system-provided image as the profile picture
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)  // Optional: Set a color for the icon
                .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(contact.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(contact.lastMessagePreview)  // A preview of the last message
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

