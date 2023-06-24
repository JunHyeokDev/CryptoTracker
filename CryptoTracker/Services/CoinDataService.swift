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
    
    private func getCoins() {
        
        guard let url = URL(string:
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        ) else { return }
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .tryMap { output -> Data in
                
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case.failure(let error):
                    print(String(describing: error))
                }
            } receiveValue: { [weak self] coin in
                self?.allcoins = coin
                self?.coinSubscription?.cancel()
            }
        
    }
    
}
