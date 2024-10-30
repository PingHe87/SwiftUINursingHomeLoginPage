//
//  ContentView.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                MainTabView()
                //ProfileView()
            }else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
