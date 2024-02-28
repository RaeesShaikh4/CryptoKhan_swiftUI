////
////  CoinImageViewModel.swift
////  Crypto_SwiftUI
////
////  Created by Vishal on 07/02/24.
////
//
//import Foundation
//import SwiftUI
//
//class CoinImageViewModel: ObservableObject {
//    @Published var image: UIImage? = nil
//    @Published var isLoading: Bool = false
//
//    private let coin: CoinModel
//    private let dataService: CoinImageService
//    private var cancellables = Set<AnyCancellable>()
//
//    init(coin: CoinModel) {
//        self.coin = coin
//        self.dataService = CoinImageService(urlString: coin.image!)
//        addSubscribers()
//    }
//
//    private func addSubscribers(){
//        dataService.$image
//            .sink { [weak self] _ in
//                self?.isLoading = false
//            } receiveValue: { [weak self] returnedImage in
//                self?.image = returnedImage
//            }
//            .store(in: &cancellables)
//    }
//
//}
//
