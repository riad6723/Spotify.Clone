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
    var height: CGFloat {
        contentView.frame.height
    }
    
    var width: CGFloat {
        contentView.frame.width
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let label1: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let label3: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: width/3, height: height)
        stackView.frame = CGRect(x: width/3, y: 0, width: 2*width/3, height: height)
        label1.frame = CGRect(x: 10, y: 0, width: stackView.frame.width, height: stackView.frame.height/3)
        label2.frame = CGRect(x: 10, y: stackView.frame.height/3, width: stackView.frame.width, height: stackView.frame.height/3)
        label3.frame = CGRect(x: 10, y: 2*stackView.frame.height/3, width: stackView.frame.width, height: stackView.frame.height/3)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        stackView.addSubview(label1)
        stackView.addSubview(label2)
        stackView.addSubview(label3)
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
