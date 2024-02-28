//
//  HomeViewModel.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 07/02/24.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var Statistics: [StatisticsModel] = []
    // Arrays
    @Published var allCoins: [CoinModel] = []
    @Published var portFolioCoins: [CoinModel] = []
    // SearchBar Text Property
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers(){
        print("addSubscribers called")
        // upadtes allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
        // Debounce for detect if user has done typing unless wont filter untill user stops
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filteredCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        //updates portFolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mappAllCoins)
            .sink { [weak self] returnedCoins in
                self?.portFolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Updates Market Data
        marketDataService.$marketData
            .combineLatest($portFolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.Statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
    }
    
    
    
    private func filteredCoins(text:String,coins:[CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        
        let lowerCasedText = text.lowercased()
        
        return coins.filter { coin in
            return coin.name!.lowercased().contains(lowerCasedText) || coin.symbol!.lowercased().contains(lowerCasedText) || coin.id!.lowercased().contains(lowerCasedText)
        }
    }
    
    private func mappAllCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel]{
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinId == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portFolioCoins: [CoinModel]) -> [StatisticsModel] {
        
        var stats: [StatisticsModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap,percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
            portFolioCoins
                .map({$0.currentHoldingsValue})
                .reduce(0, +)
        
        let previousValue =
        portFolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H! / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
                // 110 / ( 1 + 0.1 ) = 100
            }
            .reduce(0, +)
        
        let percentChange = ((portfolioValue - previousValue) / previousValue) * 100
        // (50 - 10) / 10 = 4
        // ((50 - 10) / 10) * 100 = 400
        
        let portfolio = StatisticsModel(
                title: "Portfolio Value",
                value: portfolioValue.asCurrencyWith2Decimals(),
                percentageChange: percentChange)
        
        
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
