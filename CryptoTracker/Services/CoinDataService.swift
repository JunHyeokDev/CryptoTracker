//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/24/23.
//

import Foundation
import Combine


//"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h&locale=en"


class CoinDataService {
    
    private var coinSubscription: AnyCancellable?
    
    @Published var allcoins : [Coin] = []
    
    init() {
        getCoins()
    }
    
    public func getCoins() {
        
        guard let url = URL(string:
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        ) else { return }
        
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue:  { [weak self] coin in
                self?.allcoins = coin
                self?.coinSubscription?.cancel()
            })
        
    }
    
}
