//
//  User.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 08/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import Foundation

struct User: Decodable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
    let name: String?
    let bio: String?
    let company: String?
    let blog: String?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case node_id
        case avatar_url
        case gravatar_id
        case url
        case html_url
        case followers_url
        case following_url
        case gists_url
        case starred_url
        case subscriptions_url
        case organizations_url
        case repos_url
        case events_url
        case received_events_url
        case type
        case site_admin
        case name
        case bio
        case company
        case blog
        case followers
        case following
    }
}

extension User {
    init(data: Data) throws {
        self = try JSONDecoder().decode(User.self, from: data)
    }
}

enum CellType {
    case inverted
    case normal
    case note
    case border
}


