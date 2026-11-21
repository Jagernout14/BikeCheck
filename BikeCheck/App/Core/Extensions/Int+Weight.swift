//
//  Int+Weight.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 13.11.2026.
//

import Foundation

extension Int {
    
    var kilosText: String {
        guard self > 0 else {
            return ""
        }
        return String(format: "%.1f кг", Double(self) / 1000)
    }
    
    var gramsText: String {
        guard self > 0 else {
            return ""
        }
        return "\(self) г"
    }
}
