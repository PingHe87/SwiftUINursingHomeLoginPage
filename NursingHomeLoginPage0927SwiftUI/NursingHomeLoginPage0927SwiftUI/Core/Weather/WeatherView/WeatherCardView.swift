//  WeatherCardView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 11/5/24.
//

import SwiftUI
import AVFoundation

struct WeatherCardView: View {
    var weather: ResponseBody
    private let speechService = SpeechService()  // Initialize SpeechService for speech synthesis
    
    // Function to get background image name based on weather condition
    private func backgroundImageName(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return "clear"
        case "clouds":
            return "cloud"
        case "rain", "drizzle":
            return "rain"
        case "thunderstorm":
            return "thunderstorm"
        case "snow":
            return "snow"
        case "mist", "fog":
            return "mist"
        case "wind", "squall", "tornado":
            return "windy"
        case "dust", "smoke", "ash":
            return "dust"
        default:
            return "clear"  // Default to a clear weather image
        }
    }
    
    // Function to get formatted current date
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // Format: e.g., "Nov 5, 2024"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            // Background image with blur effect
            Image(backgroundImageName(for: weather.weather.first?.main ?? "clear"))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 150)
                .clipped()
                .blur(radius: 3)  // Apply slight blur to the background image
                .cornerRadius(15)
            
            // Overlay gradient to improve text readability
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.1), Color.clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .cornerRadius(15)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(Int(weather.main.feels_like.rounded()))°F")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.8), radius: 2, x: 1, y: 1)  // Enhanced shadow for clarity
                        
                        Text(weather.weather.first?.main ?? "Unknown")
                            .font(.title2)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.8), radius: 1, x: 1, y: 1)  // Enhanced shadow for clarity
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        speakWeather()  // Action to speak the weather
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundColor(.white)  // White color for the icon
                            .padding(8)
                            .background(Color.black.opacity(0.6))  // Dark background for better contrast
                            .clipShape(Circle())
                    }
                }
                
                // Location and Date display
                HStack {
                    Text("\(weather.name)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.8), radius: 1, x: 1, y: 1)  // Enhanced shadow for clarity
                    
                    Spacer()
                    
                    Text(getCurrentDate())
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.8), radius: 1, x: 1, y: 1)  // Enhanced shadow for clarity
                }
            }
            .padding()
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9)  // Slightly reduce the card's length
        }
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
    
    // Function to speak the main weather information
    func speakWeather() {
        let weatherInfo = """
        The current weather in \(weather.name) is \(weather.weather.first?.description ?? "no description").
        The temperature feels like \(Int(weather.main.feels_like.rounded())) degrees Fahrenheit.
        """
        speechService.speak(text: weatherInfo)
    }
}

struct WeatherCardView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherCardView(weather: previewWeather)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

