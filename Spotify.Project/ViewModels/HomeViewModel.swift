//
//  HomeViewModel.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 7/8/24.
//

import Foundation

final class HomeViewModel {
        private var newReleases: NewReleasesResponse!
        private var featuredPlaylists: FeaturedPlaylistsResponse!
        private var recommendations: RecommendationsResponse!
    
    func fetchData(completion: @escaping (NewReleasesResponse?, FeaturedPlaylistsResponse?, RecommendationsResponse?) -> Void) {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getLatestReleases { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.newReleases = data
                    group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                    print("failed to fetch data")
                }
            }
        }
        
        APICaller.shared.getFeaturedPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.featuredPlaylists = data
                    group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                    print("failed to fetch data")
                }
            }
        }
        
        APICaller.shared.getRecommendedGenres { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    let genres = profile.genres
                    APICaller.shared.getRecommendations(for: Array(genres[0..<5])) { res in
                        switch res {
                        case .success(let data):
                            self?.recommendations = data
                            group.leave()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            completion(self?.newReleases, self?.featuredPlaylists, self?.recommendations)
        }
    }
}
