//
//  NewReleasesProtocol.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 16/8/24.
//

import Foundation

protocol NewReleasesProtocol {
    var name: String { get }
    var artworkURL: String { get }
    var numberOfTracks: Int { get }
    var artistName: String { get }
}

struct NewReleases: NewReleasesProtocol {
    let name: String
    let artworkURL: String
    let numberOfTracks: Int
    let artistName: String
}
