//
//  MarketDataService.swift
//  Crypto_SwiftUI

import Foundation
import Combine
import Alamofire

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription : AnyCancellable?
    
    init(){
        getData()
    }
    
    func getData() {
        //MARK: URL
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        //MARK: Alamofire
        marketDataSubscription = NetworkManager.request(url, responseType: GlobalData.self)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
            
    }
}

