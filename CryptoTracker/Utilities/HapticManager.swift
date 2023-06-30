//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 6/30/23.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
