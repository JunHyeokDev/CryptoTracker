//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/27/23.
//

import Foundation
import Combine


class MarketDataService {
    
    private var marketDataSubscription: AnyCancellable?
    
    @Published var allmarketData : MarketData? = nil
    
    init() {
        getMarketData()
    }
    
    public func getMarketData() {
        
        guard let url = URL(string:
            "https://api.coingecko.com/api/v3/global"
        ) else { return }
        
        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue:  { [weak self] marketData in
                self?.allmarketData = marketData.data
                self?.marketDataSubscription?.cancel()
            })
        
    }
    
}
