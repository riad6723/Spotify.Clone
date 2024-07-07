//
//  WelcomeViewController.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In to Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        view.addSubview(button)
        view.backgroundColor = .green
    }
    
    @objc private func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: 20, y: view.frame.size.height - 50 - view.safeAreaInsets.bottom, width: view.frame.size.width - 40, height: 50)
    }
    
    private func handleSignIn(success: Bool) {
        
    }

}
