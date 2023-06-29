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
    
    @Published var statistics: [Statistic] = []
    
    @Published var allCoins : [Coin] = []
    @Published var portfolioCoins : [Coin] = []
    @Published var searchText : String = ""

    private var cancellables: Set<AnyCancellable> = []
    
    
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    
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
        marketDataService.$allmarketData
            .map(mapGlobalMarketData)
            .sink { [weak self] statisticArray in
                self?.statistics = statisticArray
            }
            .store(in: &cancellables)
        
        // PortfolioCoin
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [Coin] in
                
                coinModels
                    .compactMap { coin -> Coin? in
                        guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id }) else { return nil }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedCoin in
                self?.portfolioCoins = returnedCoin
            }
            .store(in: &cancellables)
        
        
    }
    
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func mapGlobalMarketData(marketdata: MarketData?) -> [Statistic] {
        var stats: [Statistic] = []
        guard let data = marketdata else { return stats }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume, percentageChange: nil)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = Statistic(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
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
