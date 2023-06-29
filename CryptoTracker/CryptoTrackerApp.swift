//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/23/23.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    
    @StateObject var vm = HomeViewModel()
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
        }
    }
}
