//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/24/23.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var statistics: [Statistic] = [
        Statistic(title: "Tmp1", value: "2343"),
        Statistic(title: "Tmp1", value: "2343", percentageChange: 12.32),
        Statistic(title: "Tmp1", value: "2343", percentageChange: -23.12),
        Statistic(title: "Tmp1", value: "2343"),
    ]
    
    @Published var allCoins : [Coin] = []
    @Published var portfolioCoins : [Coin] = []
    @Published var searchText : String = ""

    private var cancellables: Set<AnyCancellable> = []
    
    private let coinDataService = CoinDataService()

    
    init() {
        addSubscription()
    }
    
    
    
    // MARK: - Add Subscription
    private func addSubscription() {
//        coinDataService.$allcoins
//            .sink { [weak self] coin in
//                self?.allCoins = coin
//            }
//            .store(in: &cancellables)
        
        $searchText
            .combineLatest(coinDataService.$allcoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoin)
            .sink { [weak self] returnedCoin in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellables)
        
        
    }
    
    
    private func filterCoin(text: String, allCoins: [Coin]) -> [Coin] {
        guard !text.isEmpty else { return  allCoins }
        
        let lowercasedText = text.lowercased() // Filtering is kinda case sensitive
        
        let filteredCoins = allCoins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
                 coin.symbol.lowercased().contains(lowercasedText) ||
                 coin.id.lowercased().contains(lowercasedText)
        }
        return filteredCoins
    }
    
}
