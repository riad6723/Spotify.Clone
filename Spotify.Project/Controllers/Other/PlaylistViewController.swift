//
//  PlaylistViewController.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import UIKit

class PlaylistViewController: UIViewController {
    let item: Item
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .darkGray
        title = item.name
        super.viewDidLoad()
    }

}
