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

struct Owner: Codable {
    let display_name: String
    let external_urls: [String: String]
    let href: String
    let id: String
    let type: String
    let uri: String
}
