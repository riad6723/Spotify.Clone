//
//  RecommendationsResponse.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 5/8/24.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [Track]
}

struct Album: Codable {
    let href: String
    let items: [Item]?
    
    let album_type: String?
    let artists: [Artist]?
    let available_markets: [String]?
    let external_urls: [String: String]?
    let id: String?
    let images: [Image]?
    let name: String?
    let release_date: String?
    let release_date_precision: String?
    let total_tracks: Int?
    let type: String?
    let uri: String?
}
