//
//  NetworkManager.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 07/02/24.
//

import Foundation
import Combine
import Alamofire

class NetworkManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse: return "[😐] Bad Response from URL"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func request<T: Decodable>(_ url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        return AF.request(url)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: T.self)
            .value()
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: DispatchQueue.main)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
