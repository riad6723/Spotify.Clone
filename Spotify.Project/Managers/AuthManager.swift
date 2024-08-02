//
//  AuthManager.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    struct Constants {
        static let clientId = "ec27591cd0e147d7b4d5794b675e6ae6"
        static let secret = "d50065b67c4d46a891d905b82774462d"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURL = "http://localhost:3036"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private var refreshingToken = false
    private var onRefreshBlocks = [(String) -> Void]()
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientId)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURL)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate = tokenExpirationDate else {
            return false
        }
        let currDate: Date = Date()
        let timeInterval: TimeInterval = 300
        let totalTime = currDate.addingTimeInterval(timeInterval)
        return totalTime >= tokenExpirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenAPIURL) else {
            print("URL is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: "\(code)"),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL),
        ]
        
        let basicToken = Constants.clientId + ":" + Constants.secret
        let data = basicToken.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            print("failed 2")
            completion(false)
            return
        }

        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("failed inside error and data with the following error : \(String(describing: error?.localizedDescription))")
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                print("The json response is: \(result)")
                completion(true)
            } catch {
                print("json conversion failed")
                completion(false)
            }
        }.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken {
            UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        }
        let currDate = Date()
        let futureDate = currDate.addingTimeInterval(TimeInterval(result.expires_in))
        UserDefaults.standard.setValue(futureDate, forKey: "expirationDate")
    }
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            refreashIfNeeded {[weak self] success in
                guard success, let accessToken = self?.accessToken else {
                    return
                }
                completion(accessToken)
            }
        } else {
            guard let accessToken = accessToken else {
                return
            }
            completion(accessToken)
        }
    }
    
    public func refreashIfNeeded(completion: @escaping (Bool) -> Void) {
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = refreshToken else {
            return
        }
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            print("URL is invalid")
            return
        }
        
        refreshingToken = true
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        let basicToken = Constants.clientId + ":" + Constants.secret
        let data = basicToken.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            completion(false)
            return
        }

        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                print("failed inside error and data with the following error : \(String(describing: error?.localizedDescription))")
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach({$0(result.access_token)})
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                print("succesfully refreshed")
                completion(true)
            } catch {
                print("json conversion failed")
                completion(false)
            }
        }.resume()
    }
}
