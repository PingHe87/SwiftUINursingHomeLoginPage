//  ActivityCardView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//

import SwiftUI

struct ActivityCardView: View {
    let activity: Activity

    // Date formatter for the weekday
    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"  // Abbreviated weekday (e.g., "Mon", "Tue")
        return formatter
    }

    // Date formatter for the day
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"  // Day of the month
        return formatter
    }

    var body: some View {
        HStack(alignment: .top) {
            // Full card container with left-aligned date block
            ZStack(alignment: .leading) {
                // Card background with rounded corners and shadow
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)


                // Card content
                HStack(alignment: .top) {
                    // Left side date block
                    VStack {
                        Text(weekdayFormatter.string(from: activity.date))
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(dayFormatter.string(from: activity.date))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 60)
                    .background(Color.blue)  // Change color to blue
                    .cornerRadius(10)
                    .padding(.trailing, 8)

                    // Right side activity details
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        HStack(spacing: 5) {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            Text("\(activity.time)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        if !activity.location.isEmpty {
                            HStack(spacing: 5) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.gray)
                                Text(activity.location)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }

                        if !activity.description.isEmpty {
                            Text(activity.description)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .lineLimit(2)  // Limit description to 2 lines
                                .truncationMode(.tail)
                        }
                    }
                }
                .padding()  // Padding inside the card
            }
            .frame(maxWidth: .infinity)  // Set card width to almost full screen with padding
        }
        .padding(.horizontal, 10)  // Add padding to keep space on the sides
        .padding(.vertical, 5)
    }
}

// Preview for development purposes
#Preview {
    ActivityCardView(activity: Activity(title: "Sample Activity", date: Date(), time: "3:00 PM", location: "Meeting Room", description: "This is a sample description for testing purposes."))
}
