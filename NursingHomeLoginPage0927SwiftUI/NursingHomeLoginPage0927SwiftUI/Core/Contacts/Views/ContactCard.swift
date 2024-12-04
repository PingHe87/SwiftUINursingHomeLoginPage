//
//  ContactCard.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct ContactCard: View {
    let contact: Contact // Contact details

    var body: some View {
        HStack(spacing: 15) {
            // Profile image with circular background
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

            // Contact details
            VStack(alignment: .leading, spacing: 5) {
                Text(contact.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(contact.email)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Message button
            NavigationLink(destination: ChatView(contact: contact)) {
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                    .padding(10)
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
            contact: Contact(id: "1", name: "John Doe", email: "john@example.com", role: "Relative")
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
