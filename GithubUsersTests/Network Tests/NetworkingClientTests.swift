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
    
    func testUsersBasicRequestGeneration(path: String) {
        let endpoint = EndpointPlugin(path: path)
        let request = endpoint.url
        
        XCTAssertEqual(request, URL(string: "https://api.github.com/users?since=0"))
    }
    
}
