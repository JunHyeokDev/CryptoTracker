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
    @State private var showFullDescription : Bool = false

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
                ChartView(coin: vm.coin)
                    .frame(height: 200)
                overView
                Divider()
                
                descriptionSection
                
                overViewGrid
                additionalDetailView
                Divider()
                additionalDetailViewGrid
                
                VStack(alignment: .leading, spacing: 20) {
                    if let websiteString = vm.websiteURL,
                       let url = URL(string: websiteString) {
                        Link(destination: url, label: {
                            Text("Website")
                        })
                        
                    }
                    
                    if let subRedditString = vm.redditURL,
                       let url = URL(string: subRedditString) {
                        Link(destination: url, label: {
                            Text("Reddit")
                        })
                    }
                }
                .tint(Color.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .padding()
            
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationTrailingItems
            }
        }
    }
}

extension DetailView {
    
    private var descriptionSection: some View {
        ZStack {
            if let readableDescriotion = vm.readableDescriotion,
               !readableDescriotion.isEmpty {
                VStack(alignment: .leading) {
                    Text(readableDescriotion)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                        .lineLimit(showFullDescription ? nil : 3)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .tint(Color.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    
    
    private var navigationTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 20, height: 20, alignment: .topTrailing)
        }
    }
    
    private var overView : some View {
        Text("OverView")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overViewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var additionalDetailView : some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalDetailViewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
            ForEach(vm.addtionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

