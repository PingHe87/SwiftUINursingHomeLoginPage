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
        ZStack(alignment: .top) {
            Color(red: 100/255, green: 153/255, blue: 233/255)  // Background color #6499E9
                .edgesIgnoringSafeArea([.top, .leading, .trailing]) // Extend background to entire screen

            ScrollView {
                VStack(spacing: 20) {
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
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    .padding([.leading, .trailing], 20)
                    
                    // Main Weather Information
                    VStack(spacing: 10) {
                        Text("\(roundedTemperature(weather.main.feels_like))°F")
                            .font(.system(size: 80))
                            .fontWeight(.bold)
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
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
        }
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
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(width: 120, height: 100)
        .background(Color.blue.opacity(0.3))
        .cornerRadius(10)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
