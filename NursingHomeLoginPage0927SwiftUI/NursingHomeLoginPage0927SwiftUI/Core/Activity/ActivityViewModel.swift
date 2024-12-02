//  ActivityViewModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/4/24.
//

import Foundation

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []

    init() {
        loadTodayActivities()
    }

    func loadTodayActivities() {
        let today = Date()
        self.activities = [
            Activity(title: "Health Check-up", date: today, time: "10:30 AM", location: "Medical Room", description: "Routine health check by the nurse.", category: "Health Management"),
            Activity(title: "Afternoon Movie", date: today, time: "02:00 PM", location: "Common Room", description: "Movie screening in the common room.", category: "Social and Entertainment"),
            Activity(title: "Nutrition Lecture", date: today, time: "11:00 AM", location: "Dining Hall", description: "Learn about balanced nutrition.", category: "Education and Learning")
        ]
    }

    // Group activities by category
    func groupedActivities() -> [String: [Activity]] {
        Dictionary(grouping: activities, by: { $0.category })
    }
}
