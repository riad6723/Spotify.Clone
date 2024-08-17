//
//  FeaturedProtocol.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 17/8/24.
//

import Foundation

protocol FeaturedProtocol {
    var url: String { get }
    var name: String { get }
    var creatorName: String { get }
}

struct FeaturedPlaylists: FeaturedProtocol {
    let url: String
    let name: String
    let creatorName: String
}
