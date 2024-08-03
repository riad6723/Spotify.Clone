//
//  Settings.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/8/24.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
