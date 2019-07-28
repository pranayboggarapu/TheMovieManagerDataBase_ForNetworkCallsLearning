//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class TMDBClient {
    
    static let apiKey = "2c164c4e494ac0c6069e610093c15dac"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getWatchlist
        case getRequestToken
        case validateLogin
        case createSession
        
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken: return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .validateLogin : return Endpoints.base + "/authentication/token/validate_with_login"
            case .createSession : return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(MovieResults.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let jsonResponse = try decoder.decode(RequestTokenResponse.self, from: data)
                if jsonResponse.success {
                    TMDBClient.Auth.requestToken = jsonResponse.requestTokenValue
                    completion(true,nil)
                }
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    class func validateLogin(userName: String, password: String, completionHandler:  @escaping (Bool, Error?) -> Void) {
        
        let body = LoginRequest(userName: userName, password: password, requestToken: TMDBClient.Auth.requestToken)
        
        var request = URLRequest(url: Endpoints.validateLogin.url)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        let jsonBody = try! encoder.encode(body)
        
        request.httpBody = jsonBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(RequestTokenResponse.self, from: data)
                Auth.requestToken = responseObject.requestTokenValue
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error)
            }
        }
        task.resume()
        
    }
    
    
    class func postNewSession(completion: @escaping (Bool, Error?) -> Void) {
        
        let body = PostSession(requestToken: TMDBClient.Auth.requestToken)
        
        var request = URLRequest(url: Endpoints.createSession.url)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        let jsonBody = try! encoder.encode(body)
        
        request.httpBody = jsonBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response)
            guard let data = data else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(SessionResponse.self, from: data)
                if responseObject.success {
                    Auth.sessionId = responseObject.sessionId
                    completion(true, nil)
                }
            } catch {
                completion(false, error)
            }
        }
        task.resume()
        
    }
        
//        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { (data, response, error) in
//            guard let data = data else {
//                completion(false, error)
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let jsonResponse = try decoder.decode(RequestTokenResponse.self, from: data)
//                if jsonResponse.success {
//                    TMDBClient.Auth.requestToken = jsonResponse.requestTokenValue
//                    completion(true,nil)
//                }
//            } catch {
//                completion(false, error)
//            }
//        }
//        task.resume()
    
    
//
//        let body = PostSession(requestToken: Auth.requestToken)
//        let encoder = JSONEncoder()
//        let jsonRequestBody = try! encoder.encode(body)
//
//        var request = URLRequest(url: Endpoints.createSession.url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonRequestBody
//
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data else {
//                completion(false, error)
//                return
//            }
//            let decoder = JSONDecoder()
//            do {
//                let responseObject = try decoder.decode(SessionResponse.self, from: data)
//                Auth.sessionId = responseObject.sessionId
//                completion(true, nil)
//            } catch {
//                completion(false, error)
//            }
//        }
//        task.resume()
//    }
//
}
