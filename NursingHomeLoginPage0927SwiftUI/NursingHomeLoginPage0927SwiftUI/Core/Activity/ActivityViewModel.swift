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
        
        // Replace with actual data loading logic if needed
        self.activities = [
            Activity(title: "Health Check-up", date: today, time: "10:30 AM", location: "Medical Room", description: "Routine health check by the nurse."),
            Activity(title: "Afternoon Movie", date: today, time: "02:00 PM", location: "Common Room", description: "Movie screening in the common room.")
        ]
    }
}
