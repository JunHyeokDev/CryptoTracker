//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 7/1/23.
//

import SwiftUI




struct DetailLoadingView: View {
    
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                Text(coin.name)
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Init DetailView for \(coin.name)")
    }
    
    
    var body: some View {
        ZStack {
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}

