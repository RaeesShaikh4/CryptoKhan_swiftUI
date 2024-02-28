//
//  HomeView.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 06/02/24.
//

import SwiftUI

enum AppearanceMode: String {
    case light, dark, system
}

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortFolio: Bool = false  //Animate Right
    @State private var showAppearanceButtons = false // Dark and Light Appearance
    @State private var showPortfolioView: Bool = false // Portfolio Page
    @State private var showSettingsView: Bool = false // Setting page
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    @AppStorage("screenAppearanceSelecetionMode") private var screenAppearanceSelecetionMode: AppearanceMode = .system
    
    var body: some View {
        ZStack {
            // BackGround Layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView(isPresented: $showPortfolioView)
                        .environmentObject(vm)
                }
            
            // Content Layer
            VStack {
                homeHeader
                
                HomeStatsView(showPortFolio: $showPortFolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPortFolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortFolio {
                    portFolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }

            if !showPortFolio {
                NavigationLink(
                    destination: SettingView(isPresented: $showSettingsView),
                    isActive: $showSettingsView
                ) {
                    EmptyView()
                }
            }
    
            // Stack For Appearance
            VStack {
                Spacer()
                HStack {
                    mainAppearanceButton
                        .onTapGesture {
                            withAnimation {
                                showAppearanceButtons.toggle()
                            }
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 16)
                    Spacer()
                }
            }
            .background(
                NavigationLink(destination: DetaiLoadingView(coin: $selectedCoin), isActive: $showDetailView, label: {
                    EmptyView()
                })
            )
        }
        .preferredColorScheme(ColorScheme(appearanceMode: screenAppearanceSelecetionMode))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

//MARK: HStack extension
extension HomeView {
    private var homeHeader : some View {
        HStack {
            CircleButtonView(iconName: showPortFolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortFolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortFolio)
                )
            Spacer()
            Text(showPortFolio ? "PortFolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortFolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortFolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumns: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var portFolioCoinsList: some View {
        List {
            ForEach(vm.portFolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumns: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortFolio{
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing)
            Button {
                withAnimation(.linear(duration: 1.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
        
    }
    
    //MARK: Main Appearance Btns
    private var mainAppearanceButton: some View {
        Button {
            withAnimation {
                switch screenAppearanceSelecetionMode {
                case .light:
                    screenAppearanceSelecetionMode = .dark
                case .dark:
                    screenAppearanceSelecetionMode = .light
                case .system:
                    screenAppearanceSelecetionMode = .light
                }
            }
        } label: {
            Image(systemName: screenAppearanceSelecetionMode == .light ? "moon.fill" : "sun.max.fill")
                .font(.system(size: 24))
                .foregroundColor(Color.white)
                .padding(10)
                .background(
                    Circle()
                        .fill(Color.theme.AccentColorButtons)
                        .shadow(radius: 5)
                )
        }
    }
}

extension ColorScheme {
    init(appearanceMode: AppearanceMode) {
        switch appearanceMode {
        case .light:
            self = .light
        case .dark:
            self = .dark
        case .system:
            self = .light
        }
    }
}


