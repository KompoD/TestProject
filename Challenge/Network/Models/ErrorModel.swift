//
//  ErrorModel.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import Foundation

struct ErrorModel: Codable {
    let error: String?
    let errorDescription: String?
    
    private enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
