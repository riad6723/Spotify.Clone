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
    
    public func getAlbumDetails(for album: Item, completion: @escaping (Result<Int, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print("my json is \(json)")
                    completion(.success(1))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    // TODO: need to know exact type of the success result
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data, error == nil else {
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
                    completion(.success(result))
                } catch {
                    print("failed \(error.localizedDescription)")
                    completion(.failure(.failedToGetData))
                }
            }.resume()
        }
    }
    
    public func getRecommendations(for genres: [String], completion: @escaping (Result<RecommendationsResponse, APIError>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=10&seed_genres=\(seeds)"), type: .GET) { request in
            print(request)
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
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
