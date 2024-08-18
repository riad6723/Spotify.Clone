//
//  RecommendationsProtocol.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 18/8/24.
//

import Foundation

protocol RecommendationsProtocol {
    var name: String { get }
    var artistName: String { get }
    var url: String { get }
}

struct Recommendations: RecommendationsProtocol {
    let name: String
    let artistName: String
    let url: String
}
