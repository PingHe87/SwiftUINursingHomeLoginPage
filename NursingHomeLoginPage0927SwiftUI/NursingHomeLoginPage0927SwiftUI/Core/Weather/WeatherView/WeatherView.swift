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
        ZStack(alignment: .leading) {
            VStack {
                // Display city name, temperature, and description
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold()
                        .font(.title)
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: "cloud")
                                .font(.system(size: 40))
                            
                            Text("\(weather.weather[0].main)")  // Weather description
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        // Feels like temperature in Fahrenheit, rounded
                        Text("\(roundedTemperature(weather.main.feels_like))°F")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .padding()
                            .lineLimit(1)
                    }
                    
                    Spacer()
                        .frame(height:  80)
                    
                    AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Weather now")
                        .bold()
                        .padding(.bottom)
                    
                    HStack {
                        // Min temperature in Fahrenheit, rounded
                        WeatherRow(logo: "thermometer", name: "Min temp", value: "\(roundedTemperature(weather.main.temp_min))°F")
                        Spacer()
                        // Max temperature in Fahrenheit, rounded
                        WeatherRow(logo: "thermometer", name: "Max temp", value: "\(roundedTemperature(weather.main.temp_max))°F")
                    }
                    
                    HStack {
                        WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + " m/s"))
                        Spacer()
                        WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            
            // Speech button at the top-right corner
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        speakWeather()  // Call the speakWeather function to speak the weather info
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.clear)
                            .clipShape(Circle())
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
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

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
