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
    private let coin : Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName : String
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        
        getCoinImage()
    }
     
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
            print("Image from fileManager!!")
        } else {
            donwloadCoinImage()
        }
    }
    
    
    private func donwloadCoinImage() {
        print("Download Image")
        guard let url = URL(string:coin.image) else { return }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue:  { [weak self] image in
                guard let self = self , let downloadedImage = image else { return }
                self.image = image
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
