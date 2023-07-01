//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 7/1/23.
//

import Foundation
import Combine

class CoinDetailDataService {
    
 //   URL : https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false

    
    private var coinDetailSubscription: AnyCancellable?
    
    @Published var coinDetail : Coin? = nil
    let coin: Coin
    
    
    init(coin: Coin) {
        self.coin = coin
        getCoins()
    }
    
    public func getCoins() {
        
        guard let url = URL(string:
                                "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false"
        ) else { return }
        
        coinDetailSubscription = NetworkManager.download(url: url)
            .decode(type: Coin.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue:  { [weak self] coin in
                self?.coinDetail = coin
                self?.coinDetailSubscription?.cancel()
            })
        
    }
    
}
