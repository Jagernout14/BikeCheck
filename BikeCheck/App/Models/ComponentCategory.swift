//
//  ComponentCategory.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 13.11.2026.
//

import Foundation

nonisolated enum ComponentCategory: String {
    case frame
    case fork
    case rims
    case hubs
    case drivetrain
    case headset
    case cockpit
    case brakes
    case suspension
    case other

    var title: String {
        switch self {
        case .frame: "Рама"
        case .fork: "Вилка"
        case .rims: "Обода"
        case .hubs: "Втулки"
        case .drivetrain: "Трансмиссия"
        case .headset: "Рулевое"
        case .cockpit: "Кокпит"
        case .brakes: "Тормоза"
        case .suspension: "Амортизатор"
        case .other: "Другое"
        }
    }

    static func title(for key: String) -> String {
        ComponentCategory(rawValue: key)?.title ?? key
    }
}
