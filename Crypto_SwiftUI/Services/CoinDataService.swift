//
//  CoinDataService.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 07/02/24.
//

import Foundation
import Combine
import Alamofire

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription : AnyCancellable?
    
    init(){
        getCoins()
    }
    
    func getCoins() {
        //MARK: URL
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        //MARK: Alamofire
        coinSubscription = NetworkManager.request(url, responseType: [CoinModel].self)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
            
    }
}

