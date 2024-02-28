//
//  HomeStatsView.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 08/02/24.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortFolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.Statistics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortFolio ? .trailing : .leading
        )
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortFolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
