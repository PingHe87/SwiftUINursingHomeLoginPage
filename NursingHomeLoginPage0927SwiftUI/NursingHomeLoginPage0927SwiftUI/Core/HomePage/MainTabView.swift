//
//  tabView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 10/30/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1  // Default to the Home tab with index 1

    init() {
        UITabBar.appearance().backgroundColor = UIColor(red: 236/255, green: 19/255, blue: 0, alpha: 1.0)  // Set background color
        UITabBar.appearance().unselectedItemTintColor = .white  // Set color for unselected tab items
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Calendar Tab
            Text("Calendar Page Placeholder")
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(selectedTab == 0 ? Color.red : Color.white)
                        .background(selectedTab == 0 ? Color.white : Color.clear)
                        .cornerRadius(10)
                }
                .tag(0)

            // Weather Tab
            WeatherView(weather: previewWeather)
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(selectedTab == 2 ? Color.red : Color.white)
                        .background(selectedTab == 2 ? Color.white : Color.clear)
                        .cornerRadius(10)
                }
                .tag(2)

            // Homepage Tab in the center
            Text("Homepage Placeholder")
                .tabItem {
                    Label("Home", systemImage: "house")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(selectedTab == 1 ? Color.red : Color.white)
                        .background(selectedTab == 1 ? Color.white : Color.clear)
                        .cornerRadius(10)
                }
                .tag(1)

            // Profile Tab on the right
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(selectedTab == 3 ? Color.red : Color.white)
                        .background(selectedTab == 3 ? Color.white : Color.clear)
                        .cornerRadius(10)
                }
                .tag(3)
        }
        .accentColor(.white)  // Set color for selected icons and text to white
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
