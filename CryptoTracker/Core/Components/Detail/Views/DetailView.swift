//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 7/1/23.
//

import SwiftUI




struct DetailLoadingView: View {
    
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Init DetailView for \(coin.name)")
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)
                
                Text("OverView")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                LazyVGrid(columns: columns,
                          alignment: .center,
                          spacing: spacing,
                          pinnedViews: [],
                          content: {
                    ForEach(vm.overviewStatistics) { stat in
                        StatisticView(stat: stat)
                    }
                }                )
                
                Text("Additional Details")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                LazyVGrid(columns: columns,
                          alignment: .center,
                          spacing: spacing,
                          pinnedViews: [],
                          content: {
                    ForEach(vm.addtionalStatistics) { stat in
                        StatisticView(stat: stat)
                    }
                })
            }
            .padding()
            
        }
        .navigationTitle(vm.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

