//
//  CalendarView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by Travis Peck on 10/30/24.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @StateObject private var calendarModel = CalendarModel()
    
    @State private var eventTitle: String = ""
    @State private var eventStartDate: Date = Date()
    @State private var eventEndDate: Date = Date()
    
    var body: some View {
        VStack {
            if calendarModel.isAccessGranted {
                Text("Calendar Access Granted!")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("Calendar Access Denied")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        
        List {
            ForEach(calendarModel.events, id: \.eventIdentifier) { event in
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.headline)
                    Text("Start: \(event.startDate)")
                    Text("End: \(event.endDate)")
                }
                .onTapGesture {
                    calendarModel.deleteEvent(eventIdentifier: event.eventIdentifier)
                }
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View{
        CalendarView()
    }
}
