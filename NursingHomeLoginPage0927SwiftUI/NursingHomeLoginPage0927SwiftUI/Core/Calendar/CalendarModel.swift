//
//  CalendarModel.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by Travis Peck on 10/29/24.
//

import Foundation
import EventKit

class CalendarModel: ObservableObject {
    private var store = EKEventStore()
    
    @Published var isAccessGranted: Bool = false
    @Published var events: [EKEvent] = []
    
    init() {
        self.store = EKEventStore()
        requestAccessToEvents()
    }
    
    private func requestAccessToEvents() {
        store.requestFullAccessToEvents(completion: { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.isAccessGranted = true
                } else {
                    self.isAccessGranted = false
                    print("Access to calendar denied: \(error?.localizedDescription ?? "No error information available")")
                }
            }
        })
    }
    
    // Method to fetch events between two dates
    func fetchEvents(startDate: Date = Date(), endDate: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()) {
        
        guard isAccessGranted else { return }
        
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        let fetchedEvents = store.events(matching: predicate)
        
        DispatchQueue.main.async {
            self.events = fetchedEvents
        }
    }
    
    func createEvent(title: String, startDate: Date, endDate: Date, notes: String? = nil) {
        guard isAccessGranted else { return }
        
        let event = EKEvent(eventStore: store)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        
        do {
            try store.save(event, span: .thisEvent)
        }catch {
            print("Failed to save event: \(error.localizedDescription)")
        }
    }
    
    func deleteEvent(eventIdentifier: String) {
        guard isAccessGranted else { return }
        
        if let event = store.event(withIdentifier: eventIdentifier) {
            do {
                try store.remove(event, span: .thisEvent)
            } catch {
                print("Failed to delete event: \(error.localizedDescription)")
            }
        }else {
            print("Event not found with provided identifier: \(eventIdentifier)")
        }
    }
}
