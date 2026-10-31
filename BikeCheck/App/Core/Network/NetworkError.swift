//
//  NetworkError.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import Foundation

nonisolated enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case decoding(Error)
    case encoding(Error)
    case noAuth
    case serverError(statusCode: Int, message: String?)
    case invalidResponse
    
    var userMessage:String {
        switch self {
        case .transport:
            return "Не удалось подключиться к серверу. Проверьте интернет и попробуйте ещё раз."
        case .noAuth:
            return "Сессия истекла  Войдите снова"
        case .serverError(_, let message):
            return message ?? "Ошибка сервера, попробуйте позже"
        case .invalidResponse, .invalidURL, .decoding, .encoding:
            return "Что-то пошло не так. Попробуйте ещё раз"
        }
    }
}

nonisolated struct ErrorResponse: Decodable {
    let detail: String
}
