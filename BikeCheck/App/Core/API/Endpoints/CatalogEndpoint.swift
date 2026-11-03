//
//  CatalogEndpoint.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 02.11.2026.
//

import Foundation

nonisolated enum CatalogEndpoint: BikeCheckEndpoint {
    case list(search: String?, category: String?, limit: Int, offset: Int)
    case createItem(NewCatalogItem)
    case getItem(id: Int)
    case updateItem(id: Int, UpdateCatalogItem)
    case deleteItem(id: Int)
    
    var path: String {
        switch self {
        case .list, .createItem:
            return "/catalog"
        case .getItem(let id), .deleteItem(let id):
            return "/catalog/\(id)"
        case .updateItem(let id, _):
            return "/catalog/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .list, .getItem:
            return .get
        case .createItem:
            return .post
        case .updateItem:
            return .patch
        case .deleteItem:
            return .delete
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let search, let category, let limit, let offset):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
            
            if let search {
                items.append(URLQueryItem(name: "q", value: search))
            }
            if let category {
                items.append(URLQueryItem(name: "category", value: category))
            }
            return items
            
        default:
            return nil
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .createItem(let item):
            return item
        case .updateItem(_, let item):
            return item
        default:
            return nil
        }
    }
}
