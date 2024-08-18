//
//  NewReleasesViewController.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 18/8/24.
//

import UIKit

class NewReleasesViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "new releases"
        view.backgroundColor = .cyan
    }
}
