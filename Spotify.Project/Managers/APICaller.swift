//
//  ApiCaller.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private init(){}
    
    enum HttpMethod: String {
        case GET
        case POST
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data, error == nil else {
                    print("here 9")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getLatestReleases(completion: @escaping (Result<NewReleasesResponse, APIError>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    print("failed")
                    completion(.failure(.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    print("failed")
                    completion(.failure(.failedToGetData))
                }
            }.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, APIError>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=50"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    print("featured \(result)")
                    completion(.success(result))
                } catch {
                    print("failed \(error.localizedDescription)")
                    completion(.failure(.failedToGetData))
                }
            }.resume()
        }
    }
    
    public func getRecommendations(for genres: [String], completion: @escaping (Result<String, APIError>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)"), type: .GET) { request in
            print(request)
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print("featured \(result)")
                    //completion(.success(result))
                } catch {
                    print("failed here in here \(error.localizedDescription)")
                    completion(.failure(.failedToGetData))
                }
            }.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, APIError>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    print("featured \(result)")
                    completion(.success(result))
                } catch {
                    print("failed \(error.localizedDescription)")
                    completion(.failure(.failedToGetData))
                }
            }.resume()
        }
    }
    
    private func createRequest(with url: URL?,type: HttpMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let url else {
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
