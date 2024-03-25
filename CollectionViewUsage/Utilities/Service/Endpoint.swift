//
//  Endpoint.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 22.03.2024.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }

    func request() -> URLRequest?
}

enum HTTPMethod: String {
    case get
    
    var HTTPValue: String {
        return self.rawValue.uppercased()
    }
}

enum Endpoint {
    case getImages
}

extension Endpoint: EndpointProtocol {

    var baseURL: String {
        return AppConstants.NetworkConstants.baseURL
    }

    var path: String {
        switch self {
        case .getImages:
            return AppConstants.NetworkConstants.photos
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getImages:
            return .get
        }
    }
    
    var headers: [String : String] {
        return [:]
    }

    func request() -> URLRequest? {
        guard let url = URL(string: baseURL + path) else {
            return nil
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
