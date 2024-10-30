//
//  tabView.swift
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

    var body: some View {
        TabView {
            // Calendar Tab
            Text("Calendar Page Placeholder")
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                        .font(.system(size: 18, weight: .bold))
                }

            // Real-time Weather Tab with WeatherView
            Group {
                if let weather = weather {
                    WeatherView(weather: weather)  // Pass real-time weather data to WeatherView
                } else if isLoading {
                    VStack {
                        Text("Loading Weather...")
                        ProgressView()
                    }
                } else {
                    Text("Failed to load weather data.")
                }
            }
            .tabItem {
                Label("Weather", systemImage: "cloud.sun")
                    .font(.system(size: 18, weight: .bold))
            }
            .onAppear {
                // Request location data on first appearance
                if !locationUpdated {
                    locationManager.requestLocation()
                }
            }
            .onReceive(locationManager.$location) { newLocation in
                // When location updates, fetch new weather data
                if let location = newLocation {
                    locationUpdated = true
                    fetchWeatherData(latitude: location.latitude, longitude: location.longitude)
                }
            }

            // Homepage Tab in the center
            Text("Homepage Placeholder")
                .tabItem {
                    Label("Home", systemImage: "house")
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
    
    // Request weather data based on location
    private func fetchWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        isLoading = true
        Task {
            do {
                weather = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude)
                isLoading = false
            } catch {
                print("Error fetching weather:", error)
                isLoading = false
            }
        }
    }
}
