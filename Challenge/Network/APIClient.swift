//
//  APIClient.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import Moya

class APIClient {
    // MARK: Singleton
    private init() {}
    private static var sharedInstance: APIClient?
    
    static func shared() -> APIClient {
        if sharedInstance == nil {
            sharedInstance = APIClient()
        }
        return sharedInstance!
    }
    
    lazy var userDefaults = UserDefaults.standard
    
    var provider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    var authProvider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin(verbose: true), AccessTokenPlugin(tokenClosure: UserDefaults.standard.string(forKey: Constants.accessToken)!)])
    
    func auth(email: String, password: String, completion: @escaping (_ isSuccess: Bool, _ message: String?, _ data: AuthModel?)->()) {
        provider.request(.auth(email: email, password: password, grantType: "password")) { result in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                
                switch statusCode {
                case 200:
                    guard let receivedData = try? JSONDecoder().decode(AuthModel.self, from: response.data) else {
                        return completion(false, "Ошибка преобразования данных", nil)
                    }
                    
                    completion(true, nil, receivedData)
                default:
                    guard let receivedError = try? JSONDecoder().decode(ErrorModel.self, from: response.data) else {
                        return completion(false, "Ошибка преобразования данных", nil)
                    }
                    completion(false, receivedError.errorDescription, nil)
                }
            case let .failure(error):
                print("Failure")
                completion(false, error.localizedDescription, nil)
            }
        }
    }
    
    func getNews(page: Int, completion: @escaping (_ isSuccess: Bool, _ message: String?, _ data: NewsListModel?)->()) {
        authProvider.request(.getAllNews(page: page, per: 20)) { result in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                
                let decoder = JSONDecoder()
                switch statusCode {
                case 200:
                    guard let receivedData = try? decoder.decode(NewsListModel.self, from: response.data) else {
                        return completion(false, "Ошибка преобразования данных", nil)
                    }
                    
                    completion(true, nil, receivedData)
                default:
                    completion(false, "Ошибка серевера - \(statusCode)", nil)
                }
            case let .failure(error):
                print("Failure")
                completion(false, error.localizedDescription, nil)
            }
        }
    }
    
    func getNews(byId id: Int, completion: @escaping (_ isSuccess: Bool, _ message: String?, _ data: CurrentNewsModel?)->()) {
        authProvider.request(.getNewsById(id: id)) { result in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                
                let decoder = JSONDecoder()
                switch statusCode {
                case 200:
                    guard let receivedData = try? decoder.decode(CurrentNewsModel.self, from: response.data) else {
                        return completion(false, "Ошибка преобразования данных", nil)
                    }
                    completion(true, nil, receivedData)
                default:
                    completion(false, "Ошибка серевера - \(statusCode)", nil)
                }
            case let .failure(error):
                print("Failure")
                completion(false, error.localizedDescription, nil)
            }
        }
    }
    
    /*func auth(login: String, password: String, completion: @escaping (_ isSuccess: Bool, _ message: String?, _ data: UserModel?)->()) {
        provider.request(.auth(login: login, password: password)) { result in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                
                /*if statusCode == 200 {
                 do {
                 let decoder = JSONDecoder()
                 let receivedData = try decoder.decode(UserModel.self, from: response.data)
                 print("True - \(receivedData)")
                 completion(true, nil, receivedData)
                 } catch let error {
                 print("Error while mapping JSON - \(error)")
                 completion(false, error.localizedDescription, nil)
                 }
                 } else {
                 completion(false, "Ошибка сервера \(statusCode)", nil)
                 }*/
                
                switch statusCode {
                case 200:
                    guard let receivedData = try? JSONDecoder().decode(UserModel.self, from: response.data) else {
                        return completion(false, "Ошибка преобразования данных", nil)
                    }
                    
                    completion(true, nil, receivedData)
                default:
                    completion(false, "Ошибка сервера \(statusCode)", nil)
                }
            case let .failure(error):
                print("Failure")
                completion(false, error.localizedDescription, nil)
            }
        }
    }
    
    func sendSMS(toNumber number: String, completion: @escaping (_ isSuccess: Bool, _ data: String)->()) {
        authProvider.request(.sendSMS(phone: number)) { result in
            switch result {
            case let .success(response):
                break
            case let .failure(error):
                break
            }
        }
    }*/
}
