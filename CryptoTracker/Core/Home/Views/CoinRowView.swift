//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/23/23.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin : Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            Spacer()
            rightColumn
        }
        .font(.subheadline)
        .padding()
    }
}


struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingsColumn: true)
    }
}

extension CoinRowView {
    private var leftColumn : some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: coin)
                .frame(width: 30,height: 30)
            Text("\(coin.symbol.uppercased())")
        }
    }
    
    private var centerColumn : some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimal())
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }

    private var rightColumn : some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimal())
                .foregroundStyle(Color.theme.accent)
            Text((coin.priceChangePercentage24H ?? 0.00).asPercentageString())
                .foregroundStyle(
                    coin.priceChangePercentage24H ?? 0 >= 0 ?
                    Color.theme.green :
                    Color.theme.red
                )
                
        }
        
    
    }
}
