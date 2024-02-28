//
//  DetailView.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 08/02/24.
//

import SwiftUI

struct DetaiLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    @State private var showFullCoinDescription: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("initializing DetailView of \(coin.name)")
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // ChartView
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    coinDescriptionSection
                    
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
            
                    linkSection
                }
                .padding()
            }
            
        }
        .scrollIndicators(.hidden)
        .navigationTitle(vm.coin.name!)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                navigationBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
            
        }
    }
}

extension DetailView {
    
    private var navigationBarTrailingItems: some View {
        HStack{
            Text(vm.coin.symbol!.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            AsyncImage(url: URL(string: vm.coin.image!)!) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                // Placeholder photo until real photo
                Image(systemName: "photo")
                //                Image(uiImage: UIImage(named: "coinPlaceHolder")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 25, height: 25)
            .clipShape(Circle())
        }
    }
    
    private var coinDescriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullCoinDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button {
                        withAnimation {
                            showFullCoinDescription.toggle()
                        }
                    } label: {
                        Text(showFullCoinDescription ? "Show less.." : "Show more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .accentColor(Color.blue)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .center,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .center,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var linkSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = vm.websiteURL, let url = URL(string: websiteString){
                Link(destination: url) {
                    Text("Website")
                }
            }
            
            if let redditString = vm.redditURL, let url = URL(string: redditString){
                Link(destination: url) {
                    Text("Reddit")
                }
            }
               
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity,alignment: .leading)
        .font(.headline)
    }
}

