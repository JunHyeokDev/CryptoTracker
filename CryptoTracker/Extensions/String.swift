//
//  String.swift
//  CryptoTracker
//
//  Created by Jun Hyeok Kim on 7/2/23.
//

import Foundation


extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var capitalizedString: String {
            return self.capitalized
    }
    
}
