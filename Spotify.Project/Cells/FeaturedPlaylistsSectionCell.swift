//
//  FeaturedPlaylistsSectionCell.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 6/8/24.
//

import Foundation
import UIKit

class FeaturedPlaylistsSectionCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistsSectionCell"
    var height: CGFloat {
        contentView.frame.height
    }
    
    var width: CGFloat {
        contentView.frame.width
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(systemName: "hammer")
        return imageView
    }()
    
    let label1: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: width/6, y: 0, width: 2*width/3, height: height/2)
        label1.frame = CGRect(x: 0, y: height/2, width: width, height: height/4)
        label2.frame = CGRect(x: 0, y: 3*height/4, width: width, height: height/4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label1.text = nil
        label2.text = nil
        imageView.image = nil
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(label1)
        contentView.addSubview(label2)
    }

    
    // MARK: - Cell Configuration
    func configure(model: FeaturedPlaylists) {
        label1.text = model.name
        label2.text = model.creatorName
        
        guard let url = URL(string: model.url) else {
            return
        }
        
        imageView.sd_setImage(with: url)
    }
}
