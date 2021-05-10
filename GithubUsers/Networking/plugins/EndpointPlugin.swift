//
//  EndpointPlugin.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 08/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import Foundation
import Combine

struct EndpointPlugin {
    var path: String
    var queryItems: [URLQueryItem] = []
    var userName: String = ""
}

// extension in which we construct the BASE URL for the API and also define headers

extension EndpointPlugin {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure()
        }
        
        return url
    }
    
    var headers: [String: Any] {
        return [:]
    }
}

// define the endpoints

extension EndpointPlugin {
    
    static var users: Self {
        return EndpointPlugin(path: "users?since=0")
    }
    
    static var userProfile: Self {
        return EndpointPlugin(path: "users/tawk")
    }
}
