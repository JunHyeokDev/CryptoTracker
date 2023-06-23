//
//  ContentView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/23/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            Text("Hello world!")
                .foregroundStyle(Color.theme.accent)
            Text("Hello world!")
                .foregroundStyle(Color.theme.red)
            Text("Hello world!")
                .foregroundStyle(Color.theme.green)
            Text("Hello world!")
                .foregroundStyle(Color.theme.secondaryText)
            Text("Hello world!")
                .foregroundStyle(Color.theme.accent)
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

