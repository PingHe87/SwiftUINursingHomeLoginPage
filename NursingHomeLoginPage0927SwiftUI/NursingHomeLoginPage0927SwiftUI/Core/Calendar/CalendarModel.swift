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
}
