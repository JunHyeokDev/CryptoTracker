//
//  CircleButtonView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/23/23.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName : String
    
    var body: some View {
        
        Image(systemName: iconName)

            .frame(width: 50, height: 50)
            .foregroundStyle(Color.theme.accent)
            .background(
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.theme.background)
            )
            .shadow(color: .theme.accent.opacity(0.25), radius: 10, x: 0, y: 0)
            .padding()

    }
}


struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(iconName: "info")
    }
}

