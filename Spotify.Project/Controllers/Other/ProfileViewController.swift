//
//  ProfileViewController.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        APICaller.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let profile):
                print(profile)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
