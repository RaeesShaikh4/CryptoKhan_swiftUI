//
//  LaunchView.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 11/02/24.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Welcome to CryptoKhan".map { String($0)}
    @State private var showLoadingText: Bool = false
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchScreen: Bool
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.launchTheme.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            
            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launchTheme.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))

                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                let lastLoadingTextIndex = loadingText.count - 1
                if counter == lastLoadingTextIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchScreen = false
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchScreen: .constant(true))
    }
}
