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
    }
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let base = "https://accounts.spotify.com/authorize"
        let redirectURL = "http://localhost:3036"
        let string = "\(base)?response_type=code&client_id=\(constants.clientId)&scope=\(scopes)&redirect_uri=\(redirectURL)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
    }
    
    private func cacheToken() {
    }
    
    public func refreashAccessToken() {
    }
}
