//
//  NewReleasesSectionCell.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 6/8/24.
//

import Foundation
import UIKit

class NewReleasesSectionCell: UICollectionViewCell {
    static let identifier = "NewReleasesSectionCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 100, y: 0, width: 250, height: 90))
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 90))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let label1: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 250, height: 30))
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 30, width: 250, height: 30))
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    let label3: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 60, width: 250, height: 30))
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label1.text = nil
        label2.text = nil
        label3.text = nil
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        stackView.addSubview(label1)
        stackView.addSubview(label2)
        stackView.addSubview(label3)
        
        //setupConstraints()
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }

    
    // MARK: - Cell Configuration
    func configure(model: NewReleases) {
        label1.text = model.name
        label2.text = model.artistName
        label3.text = String(model.numberOfTracks)
        
        guard let url = URL(string: model.artworkURL) else {
            return
        }
        imageView.sd_setImage(with: url)
    }
}
