//
//  ContactCard.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactCard: View {
    let contact: Contact // Contact details
    @State private var isShowingDetail = false // Controls the visibility of the detail view

    var body: some View {
        HStack(spacing: 15) {
            // Tap on the avatar to navigate to ContactDetailView
            Button(action: {
                // Change state variable to trigger navigation
                isShowingDetail = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                }
            }
            .buttonStyle(PlainButtonStyle()) // Removes default button styling
            .background(
                // Hidden NavigationLink to handle navigation
                NavigationLink(
                    destination: ContactDetailView(contact: contact),
                    isActive: $isShowingDetail
                ) {
                    EmptyView() // Invisible view
                }
                .hidden() // Hide the NavigationLink
            )

            // Display contact information (not clickable)
            VStack(alignment: .leading, spacing: 5) {
                Text(contact.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(contact.email)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Chat button
            NavigationLink(destination: ChatView(contact: contact)) {
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Circle().fill(Color.blue.opacity(0.1)))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ContactCard_Previews: PreviewProvider {
    static var previews: some View {
        ContactCard(
            contact: Contact(
                id: "1",
                name: "John Doe",
                email: "john@example.com",
                role: "Relative",
                tags: []
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

