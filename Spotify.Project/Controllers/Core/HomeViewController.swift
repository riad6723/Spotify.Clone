//
//  ViewController.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import UIKit

class HomeViewController: UIViewController {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return HomeViewController.createNewReleasesSection()
            case 1:
                return HomeViewController.createFeaturedPlaylistsSection()
            case 2:
                return HomeViewController.createRecommendedSection()
            default:
                return HomeViewController.createRecommendedSection()
            }
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    enum BrowseSections {
        case NewReleasesSection(model: [NewReleasesResponse])
        case FeaturedPlaylistsSection(model: [FeaturedPlaylistsResponse])
        case RecommendationsSection(model: [RecommendationsResponse])
    }
    
    private var sections = [BrowseSections]()
    private var newReleases: NewReleasesResponse!
    private var featuredPlaylists: FeaturedPlaylistsResponse!
    private var recommendations: RecommendationsResponse!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapOnButton))
        configureCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.register(NewReleasesSectionCell.self, forCellWithReuseIdentifier: NewReleasesSectionCell.identifier)
        collectionView.register(FeaturedPlaylistsSectionCell.self, forCellWithReuseIdentifier: FeaturedPlaylistsSectionCell.identifier)
        collectionView.register(RecommendationsSectionCell.self, forCellWithReuseIdentifier: RecommendationsSectionCell.identifier)
        collectionView.backgroundColor = .red
    }
    
    @objc private func didTapOnButton() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
    private static func createNewReleasesSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        // group
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, repeatingSubitem: item, count: 3)
        group.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private static func createFeaturedPlaylistsSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        // group
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.40), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, repeatingSubitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private static func createRecommendedSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        // group
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1000))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .NewReleasesSection(let model):
            return model.count
        case .FeaturedPlaylistsSection(let model):
            return model.count
        case .RecommendationsSection(let model):
            return model.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
}

extension HomeViewController {
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        APICaller.shared.getLatestReleases { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    //print("The data is here: ", data)
                    self?.newReleases = data
                    group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                    print("failed to fetch data")
                }
            }
        }
        
        APICaller.shared.getFeaturedPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    //print("The data is here: ", data)
                    self?.featuredPlaylists = data
                    group.leave()
                case .failure(let error):
                    print(error.localizedDescription)
                    print("failed to fetch data")
                }
            }
        }
        
        APICaller.shared.getRecommendedGenres { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    let genres = profile.genres
                    APICaller.shared.getRecommendations(for: Array(genres[0..<5])) { res in
                        switch res {
                        case .success(let data):
                            self?.recommendations = data
                            group.leave()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            //print("newReleases are1: \(self?.newReleases)")
            //print("newReleases are2: \(self?.featuredPlaylists)")
            //print("newReleases are3: \(self?.recommendations)")
            self?.sections.append(.NewReleasesSection(model: []))
            self?.sections.append(.FeaturedPlaylistsSection(model: []))
            self?.sections.append(.RecommendationsSection(model: []))
        }
    }
}

// MARK: TO DO
// handle fetched data into the sections array for collectionView to display
