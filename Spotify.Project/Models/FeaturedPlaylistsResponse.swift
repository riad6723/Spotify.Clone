//
//  FeaturedPlaylistsResponse.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 4/8/24.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let message: String
    let playlists: Playlist
}

struct Playlist: Codable {
    let href: String
    let items: [Item]
    let limit: Int
    let next: String
    let offset: Int
    let previous: String?
    let total: Int
}

struct Owner: Codable {
    let display_name: String
    let external_urls: [String: String]
    let href: String
    let id: String
    let type: String
    let uri: String
}
