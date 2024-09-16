//
//  NewReleasesViewController.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 18/8/24.
//

import UIKit

class NewReleasesViewController: UIViewController {
    let item: Item
    
    init(item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = item.name
        view.backgroundColor = .cyan
        
        APICaller.shared.getAlbumDetails(for: item) { result in
            switch result {
            case .success(let ans):
                print(ans)
            case .failure(let error):
                print("the error is \(error)")
            }
        }
    }
}
