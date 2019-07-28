//
//  RequestTokenResponse.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct RequestTokenResponse: Codable {
    
    let success: Bool
    let expiresAtValue: String
    let requestTokenValue: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAtValue = "expires_at"
        case requestTokenValue = "request_token"
    }
    
}
