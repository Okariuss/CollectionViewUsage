//
//  AppConstants.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 22.03.2024.
//

import Foundation

final class AppConstants {
    
    enum SpaceConstants {
        case low
        case normal
        case medium
        case high
        
        var rawValue: CGFloat {
            switch self {
            case .low:
                return 4
            case .normal:
                return 8
            case .medium:
                return 14
            case .high:
                return 20
            }
        }
    }
    
    enum RadiusConstants {
        case low
        case normal
        case medium
        case high
        
        var rawValue: CGFloat {
            switch self {
            case .low:
                return 5
            case .normal:
                return 10
            case .medium:
                return 15
            case .high:
                return 20
            }
        }
    }
    
    final class NetworkConstants {
        private init() {}
        
        static let baseURL = "https://jsonplaceholder.typicode.com/"
        static let photos = "photos?_start=0&_limit=7"
    }
}
