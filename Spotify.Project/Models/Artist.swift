//
//  Artist.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import Foundation

struct Artist: Codable {
    let external_urls: [String: String]
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
}
