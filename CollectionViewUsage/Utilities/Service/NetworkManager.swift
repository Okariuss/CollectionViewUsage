//
//  NetworkManager.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 22.03.2024.
//

import Foundation
import Combine

enum ServiceError: Error {
    case badRequest
    case unauthorized
    case notFound
    case serverError
    case decodingError
    case networkError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession

    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, ServiceError> {
        guard let request = endpoint.request() else {
            return Fail(error: ServiceError.badRequest).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ServiceError.networkError
                }

                switch httpResponse.statusCode {
                    case 200...299:
                        return data
                    case 400:
                        throw ServiceError.badRequest
                    case 401:
                        throw ServiceError.unauthorized
                    case 404:
                        throw ServiceError.notFound
                    case 500...599:
                        throw ServiceError.serverError
                    default:
                        throw ServiceError.networkError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let serviceError = error as? ServiceError {
                    return serviceError
                } else {
                    return ServiceError.decodingError
                }
            }
            .eraseToAnyPublisher()
    }
}
