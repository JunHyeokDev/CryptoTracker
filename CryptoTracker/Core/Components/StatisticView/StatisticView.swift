//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/27/23.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: Statistic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180 ), anchor: .center)
                        
                Text(stat.percentageChange?.asPercentageString() ?? "0")
            }
            .foregroundStyle(
                (stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
            
        }
    }
}


struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: dev.stat1)
    }
}

