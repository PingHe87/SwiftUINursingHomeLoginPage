//
//  NursingHomeLoginPage0927SwiftUIApp.swift
//  NursingHomeLoginPage0927SwiftUI
//
//  Created by p h on 9/27/24.
//

import SwiftUI
import Firebase


@main
struct NursingHomeLoginPage0927SwiftUIApp: App {
    
    
    
    @StateObject var viewModel = AuthViewModel()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
