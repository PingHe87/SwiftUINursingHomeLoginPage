//
//  ContentView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Group {
            // Check if the user is logged in
            if viewModel.userSession != nil {
                // Show MainTabView for all users, including admins
                MainTabView()
            } else {
                // Show LoginView if no user is logged in
                LoginView()
            }
        }
    }
}
