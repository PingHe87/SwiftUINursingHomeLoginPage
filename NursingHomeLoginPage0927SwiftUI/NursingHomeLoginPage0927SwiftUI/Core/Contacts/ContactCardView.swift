//
//  ContactCardView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/23/24.
//

import SwiftUICore
import SwiftUI

struct ContactCardView: View {
    let contact: Contact

    var body: some View {
        HStack(spacing: 12) {
            // Profile Image or Placeholder
            if let profileImage = contact.profileImage, !profileImage.isEmpty {
                AsyncImage(url: URL(string: profileImage)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Loading indicator
                            .frame(width: 60, height: 60)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }

            // Contact Information
            VStack(alignment: .leading, spacing: 5) {
                // Contact Full Name
                Text(contact.fullName)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                // Last Message Preview or Placeholder
                if let lastMessage = contact.lastMessagePreview, !lastMessage.isEmpty {
                    Text(lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                } else {
                    Text("No messages yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }

            Spacer() // Push content to the left

            // Online Status Indicator
            if let isOnline = contact.isOnline, isOnline {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.green)
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
            }
        }
        .padding()
        .background(backgroundColor(for: contact.role)) // Use role to determine background color
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    /// Returns the appropriate background color based on the role
    private func backgroundColor(for role: Contact.Role) -> Color {
        switch role {
        case .staff:
            return Color.blue.opacity(0.3)
        case .resident:
            return Color.green.opacity(0.3)
        case .relative:
            return Color.orange.opacity(0.3)
        case .unknown:
            return Color.gray.opacity(0.3)
        }
    }

    /// Placeholder image for when the profile image is unavailable
    private var placeholderImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .foregroundColor(.blue)
            .background(Color.blue.opacity(0.2))
            .clipShape(Circle())
    }
}

