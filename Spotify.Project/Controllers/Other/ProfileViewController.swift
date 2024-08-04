//
//  ProfileViewController.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import SDWebImage
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var profileDetails = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.updateUI(with: profile)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.failedToGetProfile()
                }
            }
        }
    }
}

extension ProfileViewController {
    private func updateUI(with profile: UserProfile) {
        profileDetails.append("Full Name: \(profile.display_name)")
        profileDetails.append("Email Address: \(profile.email)")
        profileDetails.append("User ID: \(profile.id)")
        profileDetails.append("Plan: \(profile.product)")
        tableView.isHidden = false
        createTableHeader(with: profile.images.first?.url)
        tableView.reloadData()
    }
    
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
    private func createTableHeader(with url: String?) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width/1.5))
        let imageSize = headerView.frame.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageSize/2
        imageView.layer.masksToBounds = true
        tableView.tableHeaderView = headerView
        
        guard let url, let url = URL(string: url) else {
            imageView.image = UIImage(systemName: "person")
            return
        }
        
        imageView.sd_setImage(with: url, completed: nil)
    }
}

extension ProfileViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = profileDetails[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
