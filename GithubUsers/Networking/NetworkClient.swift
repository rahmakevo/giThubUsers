//
//  NetworkClient.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 08/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import Foundation
import Combine

final class NetworkClient: NetworkClientProtocol {
    func get<T: Decodable>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> {
        
        // create urlRequest from custom function
        var urlRequest = URLRequest(url: url)
        headers.forEach { (key, value) in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // create a Publisher object to go and get the response from the value and publish a value
        // extract data from object
        // decode data to model of choice
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap{ result -> T in
                return try JSONDecoder().decode(T.self, from: result.data)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let endpoint = EndpointPlugin.users
        // create urlRequest from custom function
        let urlRequest = URLRequest(url: endpoint.url)
        URLSession.shared.dataTask(with: URL(string: "https://api.github.com/users?since=0")!) { data, response, error in
                   // check for error in session and confirm presence of data
                   guard let data = data, error == nil else {
                    completion(.failure(error!))
                       return
                   }
                   // convert data
                   do {
                       let results = try JSONDecoder().decode([User].self, from: data)
                    completion(.success(results))
                   } catch {
                       print("error converting data!")
                    completion(.failure("error converting data!" as! Error))
                   }
                   
        }.resume()
    }
}
