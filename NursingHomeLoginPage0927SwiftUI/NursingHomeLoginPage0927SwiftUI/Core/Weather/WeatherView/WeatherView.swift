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
            // Set background color to blue
            Color.gray
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                // Top Section: City Name and Date
                VStack(spacing: 10) {
                    Text(weather.name)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.7), radius: 1, x: 0, y: 1)
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.subheadline)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Main Weather Information
                VStack(spacing: 8) {
                    Text("\(roundedTemperature(weather.main.feels_like))°F")
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.7), radius: 2, x: 0, y: 2)
                    
                    Text(weather.weather.first?.main ?? "Unknown")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1)
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                // Additional Weather Details in Grid Layout
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    WeatherDetailCard(icon: "thermometer.low", label: "Min Temp", value: "\(roundedTemperature(weather.main.temp_min))°F")
                    WeatherDetailCard(icon: "thermometer.high", label: "Max Temp", value: "\(roundedTemperature(weather.main.temp_max))°F")
                    WeatherDetailCard(icon: "wind", label: "Wind Speed", value: "\(weather.wind.speed.roundDouble()) m/s")
                    WeatherDetailCard(icon: "humidity", label: "Humidity", value: "\(weather.main.humidity)%")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Button to speak weather info
                HStack {
                    Button(action: {
                        speakWeather()  // Speak weather info
                    }) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.title2)
                            Text("Hear Weather")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Weather")
    }
    
    // Function to speak the main weather information
    func speakWeather() {
        let weatherInfo = """
        The weather in \(weather.name) is currently \(weather.weather.first?.description ?? "no description").
        The temperature is \(roundedTemperature(weather.main.temp)) degrees Fahrenheit.
        """
        speechService.speak(text: weatherInfo)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}

