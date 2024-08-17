//
//  ViewController.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 3/7/24.
//

import UIKit

class HomeViewController: UIViewController {
    private var sections = [BrowseSections]()
    private var viewModel: HomeViewModel!
    
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
        case NewReleasesSection(model: NewReleasesResponse)
        case FeaturedPlaylistsSection(model: FeaturedPlaylistsResponse)
        case RecommendationsSection(model: RecommendationsResponse)
    }
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapOnButton))
        configureCollectionView()
        handleFetchingData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func handleFetchingData() {
        viewModel.fetchData { [weak self] newReleases, featuredPlaylists, recommendations in
            guard let newReleases, let featuredPlaylists, let recommendations else {
                return
            }
            self?.sections.append(.NewReleasesSection(model: newReleases))
            self?.sections.append(.FeaturedPlaylistsSection(model: featuredPlaylists))
            self?.sections.append(.RecommendationsSection(model: recommendations))
            self?.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.register(NewReleasesSectionCell.self, forCellWithReuseIdentifier: NewReleasesSectionCell.identifier)
        collectionView.register(FeaturedPlaylistsSectionCell.self, forCellWithReuseIdentifier: FeaturedPlaylistsSectionCell.identifier)
        collectionView.register(RecommendationsSectionCell.self, forCellWithReuseIdentifier: RecommendationsSectionCell.identifier)
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
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, repeatingSubitem: item, count: 3) //saying to stack items vertically inside the group
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
        case .NewReleasesSection(let newReleases):
            return newReleases.albums.items?.count ?? 0
        case .FeaturedPlaylistsSection(let featuredPlaylists):
            return featuredPlaylists.playlists.items.count
        case .RecommendationsSection(let recommendations):
            return recommendations.tracks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let row = indexPath.row
        
        switch section {
        case .NewReleasesSection(let newReleases):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesSectionCell.identifier, for: indexPath) as? NewReleasesSectionCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(model: .init(name: newReleases.albums.items?[row].name ?? "", artworkURL: newReleases.albums.items?[row].images.first?.url ?? "", numberOfTracks: newReleases.albums.items?[row].total_tracks ?? 0, artistName: newReleases.albums.items?[row].artists?.first?.name ?? ""))
            cell.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
            return cell
        case .FeaturedPlaylistsSection(let featuredPlaylists):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistsSectionCell.identifier, for: indexPath) as? FeaturedPlaylistsSectionCell else {
                return UICollectionViewCell()
            }
            //cell.configure(label1Text: newReleases.albums.items?.first?.name, label2Text: "newReleases.albums.release_date!", label3Text: "newReleases.albums.total_tracks!")
            cell.backgroundColor = .red
            return cell
        case .RecommendationsSection(let recommendations):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationsSectionCell.identifier, for: indexPath) as? RecommendationsSectionCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .cyan
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
}

extension HomeViewController {

}

// MARK: TO DO
// handle fetched data into the sections array for collectionView to display
// viewModel added -> work in process
