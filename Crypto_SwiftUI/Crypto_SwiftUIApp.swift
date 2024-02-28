//
//  Crypto_SwiftUIApp.swift
//  Crypto_SwiftUI

import SwiftUI

@main
struct Crypto_SwiftUIApp: App {
    // for all HomeView childs access directly
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunchScreen: Bool = true

    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        FirebaseAppWrapper.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle()) // for ipad
                .environmentObject(vm)
                ZStack {
                    if showLaunchScreen {
                        LaunchView(showLaunchScreen: $showLaunchScreen)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            
//            NavigationView {
//                HomeView()
//                    .navigationBarHidden(true)
//            }
//            .environmentObject(vm)
        }
    }
}
