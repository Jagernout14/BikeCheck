//
//  ServicesEndpoint.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 03.11.2026.
//

import Foundation

nonisolated enum ServicesEndpoint: BikeCheckEndpoint {
    case list(limit: Int, offset: Int, bikeId: Int?)
    case get(id: Int)
    case update(id: Int, UpdateService)
    case delete(id: Int)
    
    var path: String {
        switch self {
        case .list:
            return "/services"
        case .get(let id), .update(let id, _), .delete(let id):
            return "/services/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .list, .get:
            return .get
        case .update:
            return .patch
        case .delete:
            return .delete
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let limit, let offset, let bikeId):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
                
            ]
            
            if let bikeId {
                items.append(URLQueryItem(name: "bike_id", value: String(bikeId)))
            }
            return items
            
        default:
            return nil
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .update(_, let updateService):
            return updateService
        default:
            return nil
        }
    }
}
