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
        coinDataService.$allcoins
            .sink { [weak self] coin in
                self?.allCoins = coin
            }
            .store(in: &cancellables)
    }
    
}
