//
//  Login.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let userName: String
    let password: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case userName
        case password
        case requestToken = "request_token"
    }
}
