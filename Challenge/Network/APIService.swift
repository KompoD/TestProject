//
//  APIService.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import Moya

enum APIService {
    case auth(email: String, password: String, grantType: String)
    case getAllNews(page: Int, per: Int)
    case getNewsById(id: Int)
}

extension APIService: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType {
        return .bearer
    }
    
    var baseURL: URL {
        return URL(string: Constants.apiURL)!
    }
    
    var path: String {
        switch self {
        case .auth(email: _, password: _, grantType: _):
            return "/oauth/token"
        case .getAllNews(page: _, per: _):
            return "/api/v1/news"
            
        case .getNewsById(let id):
            return "/api/v1/news/\(id)"
        }
    }
    
    var method: Method {
        switch self {
        case .auth:
            return .post
        case .getAllNews,
             .getNewsById:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .auth(email, password, grantType):
            return .requestParameters(parameters: ["grant_type": grantType, "username": email, "password": password], encoding: JSONEncoding.default)
        case let .getAllNews(page, per):
            return .requestParameters(parameters: ["page": page, "per": per], encoding: URLEncoding.queryString)
        case let .getNewsById(id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json", "Client-Type": "ios"]
    }
}
