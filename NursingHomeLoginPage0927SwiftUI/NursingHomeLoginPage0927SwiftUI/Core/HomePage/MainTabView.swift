//
//  MainTabView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 10/30/24.
//

import SwiftUI
import CoreLocation

struct MainTabView: View {
    @StateObject private var locationManager = LocationManager()  // Shared LocationManager to get the user's location
    @StateObject private var weatherManager = WeatherManager()  // WeatherManager to get weather data
    @State private var weather: ResponseBody? = nil  // Holds real-time weather data
    @State private var isLoading = true  // Controls loading state
    @State private var locationUpdated = false  // Tracks if location has been updated
    
    // State variable for tab selection
    @State private var selectedTab: Int = 2  // Default to Homepage tab
    @StateObject private var activityViewModel = ActivityViewModel()

    
    var body: some View {
        TabView {
            // Calendar Tab
            CalendarView(activityViewModel: activityViewModel)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                        .font(.system(size: 18, weight: .bold))
                }
            
            // Contacts Tab with real `ContactsView`
            ContactsView()
                .tabItem {
                    Label("Contacts", systemImage: "person.2")
                        .font(.system(size: 18, weight: .bold))
                }
                .tag(1)
            
            // Homepage Tab in the center
            HomepageView()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .font(.system(size: 18, weight: .bold))
                }
                .tag(2)
            
            // Menu Tab placeholder
            MenuView()
                .tabItem {
                    Label("Menu", systemImage: "list.bullet")
                        .font(.system(size: 18, weight: .bold))
                }
            
            // Profile Tab with navigation to ProfileView
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                        .font(.system(size: 18, weight: .bold))
                }
                .environmentObject(locationManager)  // Pass location manager to ProfileView
        }
        .environmentObject(locationManager)  // Ensure shared LocationManager instance
    }
}

