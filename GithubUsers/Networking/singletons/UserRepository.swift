//
//  UserRepository.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 08/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import Foundation
import Combine

protocol UserRepositoryProtocol: class {
    var networkClient: NetworkClient { get }
    
    func getUsersAccount(name: String) -> AnyPublisher<User, Error>
    func searchUsers(completion: @escaping (Result<[User], Error>) -> Void)
}

final class UserRepository: UserRepositoryProtocol {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getUsersAccount(name: String) -> AnyPublisher<User, Error> {
        let endpoint = EndpointPlugin.userProfile
        let url = URL(string: "https://api.github.com/users/\(name)")!

           return networkClient.get(
               type: User.self,
               url: url,
               headers: endpoint.headers)
       }
    
    func searchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        return networkClient.searchUsers(completion: completion)
    }
}

