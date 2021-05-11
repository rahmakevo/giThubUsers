//
//  NetworkingClientTests.swift
//  GithubUsersTests
//
//  Created by Kevin Siundu on 11/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

@testable import GithubUsers
import XCTest

class NetworkingClientTests: XCTestCase {
    
    let endpointUsers = EndpointPlugin.users
    let endpointSearchUser = EndpointPlugin.userProfile
    let baseURL = EndpointPlugin.baseURL
    
    func testUsersEndpoint() {
        XCTAssertEqual(endpointUsers.url, URL(string: "https://api.github.com/users%3Fsince=0?"))
    }
    
    func testBaseURL() {
        XCTAssertEqual(baseURL.url, URL(string: "https://api.github.com/?"))
    }
    
}
