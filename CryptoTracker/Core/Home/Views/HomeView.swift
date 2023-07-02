//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/23/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @State private var showPortfolio: Bool = false      // For animation
    @State private var showportfolioView: Bool = false  // For new Sheet
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            Color.theme.background.ignoresSafeArea() // We can even put the new sheet at the background.. ? How is it possible.?
                .sheet(isPresented: $showportfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
            // Contents
            VStack {
                headerView
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                
                // Rows
                if !showPortfolio {
                    allCoinsList
                } else {
                    portfolioList
                }
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/) // To make the header goes to upside!
                
            }
        }
        .background(
            
            
            
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: {
                    EmptyView()
                })
        )
    }
    

    
    
}


extension HomeView {
    
    private var columnTitles : some View {
        HStack {
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOptions == .rank || vm.sortOptions == .rankReversed) ? 1.0 : 0.0 )
                    .rotationEffect(Angle(degrees: vm.sortOptions == .rank ? 0 : 180))
            }
            .onTapGesture {
                //with Animation
                vm.sortOptions = vm.sortOptions == .rank ? .rankReversed : .rank
            }
            Spacer()
            
            if showPortfolio {
                HStack{
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity( (vm.sortOptions == .holdings || vm.sortOptions == .holdingsReversed) ? 1.0 : 0.0 )
                        .rotationEffect(Angle(degrees: vm.sortOptions == .holdings ? 0 : 180))

                }
                .onTapGesture {
                    //with Animation
                    vm.sortOptions = vm.sortOptions == .holdings ? .holdingsReversed : .holdings
                }
            }
            
            Spacer()
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOptions == .price || vm.sortOptions == .priceReversed) ? 1.0 : 0.0 )
                    .rotationEffect(Angle(degrees: vm.sortOptions == .price ? 0 : 180))
            }
            .onTapGesture {
                //with Animation
                vm.sortOptions = vm.sortOptions == .price ? .priceReversed : .price
            }
            
            Button(action: {
                withAnimation(.linear(duration: 1.0)) {
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var headerView : some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none,value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showportfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Price")
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList : some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio)
                    .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: .leading))
    }
    
    private var portfolioList : some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio)
                    .listRowInsets(.init(top: 5, leading: 5, bottom: 0, trailing: 5))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: .trailing))
    }
}

// MARK: - HomeView functions

extension HomeView {
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}

