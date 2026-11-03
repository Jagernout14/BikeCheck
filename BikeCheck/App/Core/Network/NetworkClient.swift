//
//  NetworkClient.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 01.11.2026.
//

import Foundation

nonisolated final class NetworkClient {
    
    // MARK: - Private Properties
    private let storage: TokenStorageProtocol
    private let decoder: JSONDecoder
    
    // MARK: - Initializers
    init(storage: TokenStorageProtocol, decoder: JSONDecoder) {
        self.storage = storage
        self.decoder = decoder
    }
    
    // MARK: - Public Methods
    func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        let data = try await perform(endpoint)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
    
    func send(_ endpoint: any Endpoint) async throws {
        _ = try await perform(endpoint)
    }
    
    // MARK: - Private Methods
    private func perform(_ endpoint: any Endpoint) async throws -> Data {
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
        return data
    }
}
