//
//  FriendCard.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/24/24.
//

import SwiftUI

struct FriendCard: View {
    let user: User
    let onAddFriend: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(user.fullName)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onAddFriend) {
                Text("Add")
                    .font(.body)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
            .buttonStyle(PlainButtonStyle())
            .animation(.easeInOut, value: UUID())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


struct FriendCard_Previews: PreviewProvider {
    static var previews: some View {
        FriendCard(
            user: User(
                id: UUID().uuidString,
                firstName: "Alice",
                middleName: nil,
                lastName: "Smith",
                email: "alice@example.com",
                role: "resident"
            ),
            onAddFriend: { print("Friend added!") }
        )
        .previewLayout(.sizeThatFits)
    }
}
