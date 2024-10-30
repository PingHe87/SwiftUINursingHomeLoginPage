//
//  tabView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 10/30/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1  // Default to the Home tab with index 1
    private let activeColor = UIColor(red: 236/255, green: 19/255, blue: 0, alpha: 1.0)  // Red color for selected items
    private let inactiveColor = UIColor.darkGray  // Dark gray color for unselected items

    init() {
        UITabBar.appearance().backgroundColor = UIColor.white  // Set TabView background to white
        UITabBar.appearance().unselectedItemTintColor = inactiveColor  // Set unselected items to dark gray
        UITabBar.appearance().tintColor = activeColor  // Set selected items to red
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Calendar Tab
            Text("Calendar Page Placeholder")
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                        .font(.system(size: 18, weight: .bold))
                }
                .tag(0)

            // Weather Tab
            WeatherView(weather: previewWeather)
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                        .font(.system(size: 18, weight: .bold))
                }
                .tag(2)

            // Homepage Tab in the center
            Text("Homepage Placeholder")
                .tabItem {
                    Label("Home", systemImage: "house")
                        .font(.system(size: 18, weight: .bold))
                }
                .tag(1)

            // Profile Tab on the right
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                        .font(.system(size: 18, weight: .bold))
                }
                .tag(3)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
