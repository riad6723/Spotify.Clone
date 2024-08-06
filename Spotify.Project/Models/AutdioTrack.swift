//
//  AutdioTrack.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import Foundation

struct Track: Codable {
    let href: String
    let total: Int?
    
    let album: Album?
    let artists: [Artist]?
    let available_markets: [String]?
    let disc_number: Int?
    let duration_ms: Int?
    let external_ids: [String: String]?
    let external_urls: [String: String]?
    let id: String?
    let is_local: Bool?
    let name: String?
    let popularity: Int?
    let track_number: Int?
    let type: String?
    let uri: String?
}
