//
//  View.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 7/2/23.
//

import Foundation
import SwiftUI

extension View {
    func sectionHeader(headerText: String,footerText: String) -> some View {
        self.modifier(SectionHeaderView(headerText: headerText, footerText: footerText))
    }

}
