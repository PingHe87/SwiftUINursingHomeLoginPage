//  HomepageView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/4/24.
//

import SwiftUI
import CoreLocation

struct HomepageView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var activityViewModel = ActivityViewModel()
    @StateObject private var locationManager = LocationManager()  // LocationManager to get the device's location
    @State private var showingAddActivityView = false
    @State private var weather: ResponseBody? = nil  // Holds weather data

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting message for the user
                    Text("Hello, \(authViewModel.currentUser?.firstName ?? "User")!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    // Weather card view at the top
                    if let weather = weather {
                        WeatherCardView(weather: weather)
                            .padding(.bottom, 10)
                    } else {
                        // Placeholder text while loading weather data
                        Text("Loading weather...")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }

                    // Header for today's activities with an "Add" button
                    HStack {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .font(.title2)
                            Text("Today's Activities")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        // "Add" button to show the AddActivityView
                        Button(action: {
                            showingAddActivityView = true
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 5)

                    // Display activity cards
                    ForEach(activityViewModel.activities) { activity in
                        ActivityCardView(activity: activity)
                    }

                    // Emergency and contact buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            print("Emergency call tapped")
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.red)
                                Text("Call Emergency")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                        }

                        Button(action: {
                            print("Contact nurse tapped")
                        }) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.blue)
                                Text("Contact Nurse")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }

                        Button(action: {
                            print("Get help tapped")
                        }) {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Get Help")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top, 20)

                    Spacer()  // Pushes content to the top of the screen
                }
                .padding(.horizontal)
                .navigationTitle("Home")
                .sheet(isPresented: $showingAddActivityView) {
                    AddActivityView(activityViewModel: activityViewModel)
                }
            }
        }
        .onAppear {
            // Fetch weather data on appearance if the location is already available
            if let location = locationManager.location {
                fetchWeatherData(latitude: location.latitude, longitude: location.longitude)
            } else {
                locationManager.requestLocation()  // Request location if not available
            }
        }
        .onReceive(locationManager.$location) { newLocation in
            // Fetch weather data when location is updated
            if let location = newLocation {
                fetchWeatherData(latitude: location.latitude, longitude: location.longitude)
            }
        }
    }

    // Function to fetch weather data using latitude and longitude
    private func fetchWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        Task {
            do {
                let weatherData = try await WeatherManager().getCurrentWeather(latitude: latitude, longitude: longitude)
                self.weather = weatherData
            } catch {
                print("Error fetching weather data: \(error)")
            }
        }
    }
}

