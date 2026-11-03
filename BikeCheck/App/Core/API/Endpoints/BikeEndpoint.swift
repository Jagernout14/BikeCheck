//
//  BikeEndpoint.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 02.11.2026.
//

import Foundation

nonisolated enum BikeEndpoint: BikeCheckEndpoint {
    case list
    case create(NewBike)
    case get(id: Int)
    case update(id: Int, UpdateBike)
    case delete(id: Int)
    case listComponent(id: Int)
    case installComponent(id: Int, NewComponent)
    
    var path: String {
        switch self {
        case .list, .create:
            return "/bikes"
        case .get(let id), .update(let id, _), .delete(let id):
            return "/bikes/\(id)"
        case .listComponent(let id), .installComponent(let id, _):
            return "/bikes/\(id)/components"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .list, .get, .listComponent:
            return .get
        case .create, .installComponent:
            return .post
        case .update:
            return .patch
        case .delete:
            return .delete
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .list, .get, .delete, .listComponent:
            return nil
        case .create(let bike):
            return bike
        case .update(_, let updateBike):
            return updateBike
        case .installComponent(_, let newComponent):
            return newComponent
        }
    }
}
