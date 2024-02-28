//
//  PortfolioView.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 08/02/24.
//

import SwiftUI

struct PortfolioView: View {
    
    @Binding var isPresented: Bool
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading,spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                
                }
                .padding()
            }
            .navigationTitle("Edit PortFolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(isPresented: $isPresented)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
    
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(isPresented: .constant(false))
            .environmentObject(HomeViewModel())
        
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal,showsIndicators: true) {
            LazyHStack(spacing: 15) {
                ForEach(vm.searchText.isEmpty ? vm.portFolioCoins : vm.allCoins) { coin in
                    CoinImageView(coin: coin)
                        .frame(width: 70)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                               updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
//            .padding(.vertical, 4) // adding animation on selection
            .frame(height: 120)
            .padding(.leading, 2)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portFolioCoins.first(where: {$0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
        
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol?.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice?.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex. 1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButtons: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            
            Button {
                saveBtnPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            )
            
        }
        .font(.headline)
    }
    
    private func saveBtnPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
            else { return }
        
        // save portfolio section
        vm.updatePortfolio(coin: coin, amount: amount)
        
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
}
