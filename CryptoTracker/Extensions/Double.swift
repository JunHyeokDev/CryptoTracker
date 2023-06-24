//
//  Double.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/24/23.
//

import Foundation

extension Double {
        
    private var currencyFormatter: Formatter {
        let formatter = NumberFormatter()
    
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        
        return formatter
    }
    
    func asCurrencyWith6Decimal() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter.string(for: number) ?? "$0.00"
    }
    
    func asNumberToString() -> String {
        return String(format: "%.2f",self)
    }
    
    func asPercentageString() -> String {
        return asNumberToString() + "%"
    }
    
}
