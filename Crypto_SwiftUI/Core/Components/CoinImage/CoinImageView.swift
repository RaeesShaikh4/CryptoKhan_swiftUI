////
////  CoinImageView.swift
////  Crypto_SwiftUI
////
////  Created by Vishal on 07/02/24.
////
//
import SwiftUI

//struct CoinImageView: View {
//    let coin: CoinModel
//
//    var body: some View {
//        AsyncImage(url: URL(string: coin.image!)!) { image in
//            image.resizable()
//                .aspectRatio(contentMode: .fit)
//        } placeholder: {
//            // Placeholder or loading view
//            Image(systemName: "photo")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//        }
//        .frame(width: 50, height: 50)
//        .clipShape(Circle())
//
//        Text(coin.symbol?.uppercased() ?? "")
//            .font(.caption)
//            .foregroundColor(Color.theme.accent)
//    }
//}

// for vertical view
struct CoinImageView: View {
    let coin: CoinModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: coin.image!)!) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                // Placeholder or loading view
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            Text(coin.symbol?.uppercased() ?? "")
                .font(.caption)
                .foregroundColor(Color.theme.accent)
        }
    }
}
