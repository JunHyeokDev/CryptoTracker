//
//  CoinLogoView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/28/23.
//

import SwiftUI

struct CoinLogoView: View {
    
    let coin : Coin
    
    var body: some View {
        
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(coin.name)
                .foregroundStyle(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(1.0)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: dev.coin)
    }
}

