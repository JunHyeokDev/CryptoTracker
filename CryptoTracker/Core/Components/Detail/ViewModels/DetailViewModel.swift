//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 7/1/23.
//

import Foundation
import Combine


class DetailViewModel : ObservableObject{
    
    @Published var overviewStatistics: [Statistic] = []
    @Published var addtionalStatistics: [Statistic] = []
    
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    @Published var coin: Coin
    private let coinDetailService : CoinDetailDataService
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(coin: Coin){
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    
    private func addSubscribers() {
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedCoin) in
                self?.overviewStatistics = returnedCoin.overview
                self?.addtionalStatistics = returnedCoin.additional
            }
            .store(in: &cancellables)
        coinDetailService.$coinDetail
            .sink { [weak self] coinDetail in
                self?.coinDescription = coinDetail?.description?.en
                self?.websiteURL = coinDetail?.links?.homepage?.first
                self?.redditURL = coinDetail?.links?.subredditURL
            }
            .store(in: &cancellables)
        
    }
    
    
    private func mapDataToStatistics(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        let currentPrice = Statistic(title: "Current Price", value: coin.currentPrice.asCurrencyWith2Decimal(), percentageChange: coin.priceChangePercentage24H ?? 0)
        
        let marketCapValue = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCap = Statistic(title: "Market Cap", value: marketCapValue, percentageChange: coin.marketCapChangePercentage24H)
        let rank = Statistic(title: "Rank", value: String(coin.rank))
        let volume = Statistic(title: "Volume", value: coin.totalVolume?.formattedWithAbbreviations() ?? "$ 0")
//
        let overviewArray : [Statistic] = [
            currentPrice,marketCap,rank,volume
        ]
//
        let high24H = Statistic(title: "24h High", value: coin.high24H?.asCurrencyWith2Decimal() ?? "N/A")
        let low24H = Statistic(title: "24h Low", value: coin.low24H?.asCurrencyWith2Decimal() ?? "N/A")
        let priceChange24H =
        Statistic(title: "24h Price Change",
                  value: coin.priceChange24H?.asCurrencyWith2Decimal() ?? "N/A" ,
                  percentageChange: coin.priceChangePercentage24H)
        let marketCapChange24H = Statistic(title: "24h Market Cap Change", value: coin.marketCapChange24H?.formattedWithAbbreviations() ?? "", percentageChange: coin.marketCapChangePercentage24H)
//
        let additionalArray : [Statistic] = [
            high24H,low24H,priceChange24H,marketCapChange24H
        ]
        
        return( overviewArray,additionalArray )
    }
    
    var readableDescriotion: String? {
        coinDescription?.removingHTMLTags()
    }
}
