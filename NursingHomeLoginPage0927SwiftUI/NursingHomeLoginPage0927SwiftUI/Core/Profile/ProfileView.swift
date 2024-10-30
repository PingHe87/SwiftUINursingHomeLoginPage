//
//  ProfileView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import SwiftUI
import CoreLocation

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var weatherManager = WeatherManager()  // Initialize WeatherManager to fetch weather data
    @State private var weatherData: ResponseBody? = nil  // Holds the weather data
    @State private var isLoading = true  // Indicates if the weather data is still loading

    var body: some View {
        NavigationView {  // Add NavigationView to enable navigation
            List {
                // User profile section
                Section {
                    HStack {
                        Text(authViewModel.currentUser?.initials ?? "")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authViewModel.currentUser?.fullname ?? "Unknown")
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .padding(.top, 4)
                            
                            Text(authViewModel.currentUser?.email ?? "No email")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }

                // Weather section with NavigationLink to WeatherView
                Section("Weather") {
                    if isLoading {
                        // Show loading text while fetching weather data
                        Text("Loading weather data...")
                    } else if let weather = weatherData {
                        // When data is loaded, navigate to WeatherView with weather data
                        NavigationLink(destination: WeatherView(weather: weather)) {
                            HStack {
                                Image(systemName: "cloud.sun.fill")
                                    .foregroundColor(.blue)
                                Text("View Weather")
                                    .foregroundColor(.primary)
                            }
                        }
                    } else {
                        // Show error text if weather data failed to load
                        Text("Failed to load weather data.")
                    }
                }

                // Account section with Sign Out button
                Section("Account") {
                    Button {
                        // Call sign out function
                        authViewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                }
                
            }
            .onAppear {
                // Load weather data when the view appears
                Task {
                    await loadWeather()
                }
            }
            .navigationTitle("Profile")  // Set navigation title
        }
    }

    // Async function to fetch weather data using WeatherManager
    private func loadWeather() async {
        do {
            let location = CLLocation(latitude: 32.7767, longitude: -96.7970)  // Dallas coordinates for testing
            let fetchedWeatherData = try await weatherManager.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            // Ensure updating UI on the main thread
            DispatchQueue.main.async {
                self.weatherData = fetchedWeatherData
                self.isLoading = false
            }
        } catch {
            print("Error loading weather data: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

}

#Preview {
    ProfileView()
}
