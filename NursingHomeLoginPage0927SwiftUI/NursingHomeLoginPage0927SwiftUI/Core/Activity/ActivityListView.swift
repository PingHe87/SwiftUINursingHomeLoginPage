//
//  ActivityListView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/2/24.
//
import SwiftUI

struct ActivityListView: View {
    @ObservedObject var activityViewModel: ActivityViewModel

    var body: some View {
        List {
            ForEach(["Health Management", "Social and Entertainment", "Education and Learning", "Family Interaction", "Daily Affairs"], id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(activityViewModel.activities.filter { $0.category == category }) { activity in
                        ActivityCardView(activity: activity)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}
