//
//  Endpoints.swift
//  ReactiveWeatherApp
//
//  Created by Сергей Филиппов on 16.04.2018.
//  Copyright © 2018 spacedema. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "http://api.openweathermap.org/"
    static let apiKey = "6fe95bb8e41b80a33bdabf14d71b0608"
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

enum Endpoints {
    
    enum Cities: Endpoint {
        case fetch
        
        public var path: String {
            switch self {
            case .fetch: return "/data/2.5/find"
            }
        }
        
        public var url: String {
            switch self {
            case .fetch: return "\(API.baseUrl)\(path)"
            }
        }
    }
    
    enum FiveDayForecast: Endpoint {
        case fetch
        
        public var path: String {
            switch self {
            case .fetch: return "data/2.5/forecast/"
            }
        }
        
        public var url: String {
            switch self {
            case .fetch: return "\(API.baseUrl)\(path)"
            }
        }
    }
    
    enum Image: Endpoint {
        case fetch
        
        public var path: String {
            switch self {
            case .fetch: return "/img/w"
            }
        }
        
        public var url: String {
            switch self {
            case .fetch: return "\(API.baseUrl)\(path)/"
            }
        }
    }
}
