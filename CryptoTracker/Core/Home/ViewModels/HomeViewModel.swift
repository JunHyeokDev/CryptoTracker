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
    @Published var isLoading : Bool = false
    @Published var allCoins : [Coin] = []
    @Published var portfolioCoins : [Coin] = []
    @Published var searchText : String = ""
    @Published var sortOptions : SortOption = .holdings
    
    private var cancellables: Set<AnyCancellable> = []
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
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
            .combineLatest(coinDataService.$allcoins,$sortOptions)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoin in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellables)
        
        // PortfolioCoin
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoin in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoindsIfNeeded(coins: returnedCoin)
            }
            .store(in: &cancellables)
        
        marketDataService.$allmarketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] statisticArray in
                self?.statistics = statisticArray
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, allCoins: [Coin], sort: SortOption) -> [Coin]  {
        let filteredCoins = filterCoin(text: text, allCoins: allCoins)
        let sortedCoins = sortCoins(sort: sort, coins: filteredCoins)
        return sortedCoins
        
    }
    
    private func sortCoins(sort: SortOption, coins:[Coin]) -> [Coin] {
        switch sortOptions {
        case .rank, .holdings:
            return coins.sorted(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            return coins.sorted(by: {$0.rank > $1.rank})
        case .price:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .priceReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        }
    }
    
    private func sortPortfolioCoindsIfNeeded(coins: [Coin]) -> [Coin] {
        // will only sort by holdings or reversedholdings if needed
        switch sortOptions{
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioCoins: [Portfolio]) -> [Coin] {
        allCoins
            .compactMap { coin -> Coin? in
                guard let entity = portfolioCoins.first(where: {$0.coinID == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketdata: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        guard let data = marketdata else { return stats }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume, percentageChange: nil)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        
        let portfolioValue = portfolioCoins
                                .map({$0.currentHoldingsValue})
                                .reduce(0, +)
        
        let previousValue = portfolioCoins
                .map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
                }
                .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith6Decimal(), percentageChange: percentageChange)
      
        
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
