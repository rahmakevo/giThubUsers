//
//  NetworkClientProtocol.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 08/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import Foundation
import Combine

// define a method for querying a single codable object

protocol NetworkClientProtocol: class {
    typealias Headers = [String: Any]
    
    func get<T>(
        type: T.Type,
        url: URL,
        headers: Headers) -> AnyPublisher<T, Error> where T: Decodable
    
    func searchUsers(completion: @escaping (Result<[User], Error>) -> Void)
}
