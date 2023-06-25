//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/25/23.
//

import Foundation
import SwiftUI
import Combine


class CoinImageViewModel : ObservableObject{
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let coin : Coin
    private let dataService: CoinImageService
    
    init(coin: Coin) {
        self.coin = coin
        self.dataService = CoinImageService(urlString: coin.image)
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

        
    }
}

