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
    
    static let uiDate = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    static func makeDateString(from apiString: String) -> String {
        guard let date = apiDate.date(from: apiString) else {
            return apiString
        }
        return uiDate.string(from: date)
    }
}
