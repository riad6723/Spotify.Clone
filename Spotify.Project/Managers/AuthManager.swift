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
    
    struct constants {
        static let clientId = "ec27591cd0e147d7b4d5794b675e6ae6"
        static let secret = "d50065b67c4d46a891d905b82774462d"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let base = "https://accounts.spotify.com/authorize"
        let redirectURL = "http://localhost:3036"
        let string = "\(base)?response_type=code&client_id=\(constants.clientId)&scope=\(scopes)&redirect_uri=\(redirectURL)&show_dialog=TRUE"
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
        return nil //TO DO
    }
    
    private var shouldRefreshToken: Bool {
        return false // TO DO
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: constants.tokenAPIURL) else {
            print("URL is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: "\(code)"),
            URLQueryItem(name: "redirect_uri", value: "http://localhost:3036"),
        ]
        
        let basicToken = constants.clientId + ":" + constants.secret
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
                print("failed inside data and error checking with error : \(String(describing: error?.localizedDescription))")
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                print("The json response is: \(result)")
                completion(true)
            } catch {
                print("json convertion failed")
                completion(false)
            }
        }.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        //UserDefaults.standard.setValue(Data().addingTi, forKey: "access_token"), .... NEED TO ADD TIME INTERVAL HERE INTO USERDEFAULTS
    }
    
    public func refreashAccessToken() {
    }
}
