////
////  CoinImageService.swift
////  Crypto_SwiftUI
////
////  Created by Vishal on 07/02/24.
////
//
//import Foundation
//import SwiftUI
//import Combine
//import Alamofire
//import AlamofireImage
//
//class CoinImageService {
//    
//    @Published var image: UIImage? = nil
//    
//   private var imageSubscription: AnyCancellable?
//    var imageRequest: DataRequest?
//    
//    
//    init(urlString: String){
//        getCoinImage(urlString: urlString)
//    }
//    
//    private func getCoinImage(urlString:String){
//        guard let url = URL(string: urlString) else { return }
//        
//        // Use AlamofireImage to download images
//        imageRequest = AF.request(url).responseData { [weak self] response in
//            if case .success(let data) = response.result {
//                self?.image = UIImage(data: data)
//                print("Image fetched successfully from URL: \(urlString)")
//            } else {
//                print("Failed to fetch image from URL: \(urlString)")
//            }
//        }
//    }
//    
//    func cancelImageRequest() {
//        imageRequest?.cancel()
//    }
//}
