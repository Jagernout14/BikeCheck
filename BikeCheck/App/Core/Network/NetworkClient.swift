//
//  NetworkClient.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 01.11.2026.
//

import Foundation

nonisolated final class NetworkClient {
    private let storage: TokenStorageProtocol
    private let decoder: JSONDecoder
    
    init(storage: TokenStorageProtocol, decoder: JSONDecoder) {
        self.storage = storage
        self.decoder = decoder
    }
    
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        var request = try endpoint.makeRequest()
        
        if endpoint.requiresAuth {
            guard let token = storage.token else {
                throw NetworkError.noAuth
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.transport(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401 where endpoint.requiresAuth:
            throw NetworkError.noAuth
        default:
            let message = try? decoder.decode(ErrorResponse.self, from: data).detail
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: message)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
