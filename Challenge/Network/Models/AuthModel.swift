//
//  AuthModel.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import Foundation

struct AuthModel: Codable {
    let accessToken: String?
    //let tokenType: String?
    let expiresIn: Int?
    let refreshToken: String?
    let createdAt: Int?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        //case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
    }
}
