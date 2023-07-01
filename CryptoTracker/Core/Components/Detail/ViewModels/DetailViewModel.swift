//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 7/1/23.
//

import Foundation
import Combine


class DetailViewModel : ObservableObject{
    
    private let coindDetailService : CoinDetailDataService
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(coin: Coin){
        self.coindDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    
    private func addSubscribers() {
        coindDetailService.$coinDetail
            .sink { returnedCoin in
                print(returnedCoin)
            }
    }
}
