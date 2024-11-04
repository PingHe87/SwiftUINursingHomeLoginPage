//
//  WeatherView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 10/17/24.
//

import SwiftUI
import AVFoundation

struct WeatherView: View {
    var weather: ResponseBody
    private let speechService = SpeechService()  // Initialize SpeechService for speech synthesis
    
    // Helper function to round temperature to the nearest integer
    func roundedTemperature(_ temp: Double) -> Int {
        return Int(temp.rounded())
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.4)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.top)  // Extend background only to the top, not full screen
            
            ScrollView {
                VStack(spacing: 30) {
                    // Top Section: City Name and Date
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(weather.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                speakWeather()  // Speak weather info
                            }) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 20)
                    
                    // Main Weather Information
                    VStack(spacing: 15) {
                        Text("\(roundedTemperature(weather.main.feels_like))°F")
                            .font(.system(size: 100))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Text(weather.weather.first?.main ?? "Unknown")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)
                    
                    // Additional Weather Details in Card
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            WeatherDetailCard(icon: "thermometer.low", label: "Min Temp", value: "\(roundedTemperature(weather.main.temp_min))°F")
                            WeatherDetailCard(icon: "thermometer.high", label: "Max Temp", value: "\(roundedTemperature(weather.main.temp_max))°F")
                        }
                        
                        HStack(spacing: 20) {
                            WeatherDetailCard(icon: "wind", label: "Wind Speed", value: "\(weather.wind.speed.roundDouble()) m/s")
                            WeatherDetailCard(icon: "humidity", label: "Humidity", value: "\(weather.main.humidity)%")
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Weather")  // Set a title that works within the TabView
    }
    
    // Function to speak the main weather information
    func speakWeather() {
        let weatherInfo = """
        The weather in \(weather.name) is currently \(weather.weather.first?.description ?? "no description").
        The temperature is \(roundedTemperature(weather.main.temp)) degrees Fahrenheit.
        """
        speechService.speak(text: weatherInfo)  // Use temperature with rounding
    }
}

// A reusable card view for weather details
struct WeatherDetailCard: View {
    var icon: String
    var label: String
    var value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
            
            Text(label)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(width: 130, height: 120)
        .background(Color.blue.opacity(0.4))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}

