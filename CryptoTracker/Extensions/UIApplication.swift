//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/26/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing () {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
