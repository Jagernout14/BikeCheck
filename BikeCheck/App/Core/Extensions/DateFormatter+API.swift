//
//  DateFormatter+API.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 15.11.2026.
//

import Foundation

extension DateFormatter {
    static let apiDate = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
