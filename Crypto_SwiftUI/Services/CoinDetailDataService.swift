//
//  CoinDetailDataService.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 09/02/24.
//

import Foundation
import Combine
import Alamofire

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailSubscription : AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinsDetails()
    }
    
    private func getCoinsDetails() {
        print("getCoinsDetails called---")
        //MARK: URL
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id!)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        //MARK: Alamofire
        coinDetailSubscription = NetworkManager.request(url, responseType: CoinDetailModel.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching coin details: \(error)")
                }
            }, receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
