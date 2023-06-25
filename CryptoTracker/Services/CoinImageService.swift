//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/25/23.
//

import Foundation
import SwiftUI
import Combine



class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    
    init(urlString: String) {
        getCoinImage(urlString: urlString)
    }
    
    private func getCoinImage(urlString: String) {
        
        guard let url = URL(string:urlString) else { return }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue:  { [weak self] image in
                self?.image = image
                self?.imageSubscription?.cancel()
            })
    }
}
