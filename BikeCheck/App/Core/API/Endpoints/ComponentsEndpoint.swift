//
//  ComponentsEndpoint.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 03.11.2026.
//

import Foundation

nonisolated enum ComponentsEndpoint: BikeCheckEndpoint {
    case get(id: Int)
    case update(id: Int, UpdateComponent)
    case remove(id: Int)
    case listService(id: Int)
    case addService(id: Int, NewService)
    
    var path: String {
        switch self {
        case .get(let id), .update(let id, _), .remove(let id):
            return "/components/\(id)"
        case .listService(let id), .addService(let id, _):
            return "/components/\(id)/services"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .get, .listService:
            return .get
        case .update:
            return .patch
        case .remove:
            return .delete
        case .addService:
            return .post
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .get, .remove, .listService:
            return nil
        case .update(_, let updateComponent):
            return updateComponent
        case .addService(_, let newService):
            return newService
        }
    }
}
