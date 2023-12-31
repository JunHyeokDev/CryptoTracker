//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/28/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedCoin: Coin? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar (content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText) { value in
                if value == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}


extension PortfolioView {
    
    private var trailingNavBarButton: some View {
        HStack(spacing: 10) {
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            )
            
        }
        .font(.headline)
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}), let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
        
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection: some View {
        VStack (spacing: 20) {
            HStack {
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith2Decimal() ?? "")
            }
            Divider()
            HStack {
                Text("Amount in your portfolio")
                Spacer()
                TextField("Ex : 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimal())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private var coinLogoList: some View {
        ScrollView(.horizontal,showsIndicators: true) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedCoin = coin
                                if let selectedCoin = selectedCoin {
                                    updateSelectedCoin(coin: selectedCoin)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?  Color.theme.green : Color.clear
                                        , lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding()
        }
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
              let amount = Double(quantityText)
                    else { return }
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // hide check mark
        UIApplication.shared.endEditing()

    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        
    }
    
}
