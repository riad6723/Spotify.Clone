//
//  Item.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 4/8/24.
//

import Foundation

struct Item: Codable {
    let album_type: String?
    let artists: [Artist]?
    let available_markets: [String]?
    let release_date: String?
    let release_date_precision: String?
    let total_tracks: Int?
    
    let external_urls: [String: String]
    let href: String
    let id: String
    let images: [Image]
    let type: String
    let uri: String
    
    let collaborative: Bool?
    let description: String?
    let name: String?
    let owner: Owner?
    let primary_color: String?
    let snapshot_id: String?
    let tracks: Track?
}
