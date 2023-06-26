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
            .combineLatest($allCoins)
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
