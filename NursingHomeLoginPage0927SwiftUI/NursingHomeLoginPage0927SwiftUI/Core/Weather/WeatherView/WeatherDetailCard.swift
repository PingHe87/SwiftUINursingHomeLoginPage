//  WeatherDetailCard.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 10/17/24.
//

import SwiftUI

struct WeatherDetailCard: View {
    var icon: String
    var label: String
    var value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .shadow(color: Color.gray.opacity(0.7), radius: 1, x: 0, y: 1)  // Add shadow
            
            Text(label)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: Color.gray.opacity(0.5), radius: 1, x: 0, y: 1)  // Add shadow
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .shadow(color: Color.gray.opacity(0.7), radius: 1, x: 0, y: 1)  // Add shadow
        }
        .frame(maxWidth: .infinity, minHeight: 120)  // Ensure cards have equal width and a minimum height
        .background(Color.blue.opacity(0.4))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct WeatherDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailCard(icon: "thermometer.low", label: "Min Temp", value: "32°F")
    }
}
