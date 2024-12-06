//
//  CalendarView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 12/5/24.
//

import SwiftUI
import EventKit

struct CalendarView: View {
    @ObservedObject var activityViewModel: ActivityViewModel
    @StateObject private var calendarManager = CalendarManager() // Manage system calendar
    @State private var selectedDate: Date? = nil
    @State private var showDetail = false

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack {
            // Month navigation
            HStack {
                Button(action: {
                    // Navigate to the previous month
                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate ?? Date())
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }

                Spacer()

                Text("\(formattedMonthYear(for: selectedDate ?? Date()))")
                    .font(.headline)
                    .padding()

                Spacer()

                Button(action: {
                    // Navigate to the next month
                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate ?? Date())
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)

            // Weekday headers
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }

            // Grid of days
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(daysInMonth(for: selectedDate ?? Date()), id: \.self) { date in
                    let hasEvent = calendarManager.hasEvent(on: date)
                    let hasActivity = activityViewModel.activities.contains { calendar.isDate($0.date, inSameDayAs: date) }

                    Text("\(calendar.component(.day, from: date))")
                        .font(.body)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background((hasEvent || hasActivity) ? Color.blue.opacity(0.5) : Color.clear)
                        .clipShape(Circle()) // Circular highlight for dates
                        .onTapGesture {
                            selectedDate = date
                            showDetail = true
                        }
                }
            }
            .padding(.bottom, 20)

            // Display details for selected date
            if let selectedDate = selectedDate {
                VStack {
                    Text("Events on \(formattedDate(for: selectedDate))")
                        .font(.headline)
                        .padding()

                    let selectedDayActivities = activityViewModel.activities
                        .filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
                        .sorted { $0.time > $1.time } // Sort by time

                    if calendarManager.events(on: selectedDate).isEmpty &&
                        selectedDayActivities.isEmpty {
                        Text("No events for this day")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView {
                            // Custom activities
                            ForEach(selectedDayActivities) { activity in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(activity.title)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text("Time: \(activity.time)")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    Text("Location: \(activity.location)")
                                        .font(.subheadline)
                                    Text(activity.description)
                                        .font(.subheadline)
                                    Divider()
                                }
                                .padding(.horizontal)
                            }

                            // System calendar events
                            ForEach(calendarManager.events(on: selectedDate), id: \.eventIdentifier) { event in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(event.title)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text("Time: \(formattedTime(for: event.startDate)) - \(formattedTime(for: event.endDate))")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    Divider()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(15)
                .padding()
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
        }
        .onAppear {
            calendarManager.requestAccess() // Request access to the system calendar
        }
    }

    // Format month and year
    private func formattedMonthYear(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    // Format the date
    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Format the time
    private func formattedTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // Get all dates in a month
    private func daysInMonth(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth) }
    }
}

// CalendarManager: Manage system calendar events
class CalendarManager: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var events: [EKEvent] = []

    func requestAccess() {
        eventStore.requestAccess(to: .event) { granted, _ in
            if granted {
                self.fetchEvents()
            }
        }
    }

    func fetchEvents() {
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        DispatchQueue.main.async {
            self.events = self.eventStore.events(matching: predicate)
        }
    }

    func hasEvent(on date: Date) -> Bool {
        events.contains { Calendar.current.isDate($0.startDate, inSameDayAs: date) }
    }

    func events(on date: Date) -> [EKEvent] {
        events.filter { Calendar.current.isDate($0.startDate, inSameDayAs: date) }
    }
}
