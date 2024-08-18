//
//  RecommendationsSectionCell.swift
//  Spotify.Project
//
//  Created by Ajijul Hakim Riad on 6/8/24.
//

import Foundation
import UIKit

class RecommendationsSectionCell: UICollectionViewCell {
    static let identifier = "RecommendationsSectionCell"
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
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: width/3, height: height)
        stackView.frame = CGRect(x: width/3, y: 0, width: 2*width/3, height: height)
        label1.frame = CGRect(x: 10, y: 0, width: stackView.frame.width, height: stackView.frame.height/2)
        label2.frame = CGRect(x: 10, y: stackView.frame.height/2, width: stackView.frame.width, height: stackView.frame.height/2)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        stackView.addSubview(label1)
        stackView.addSubview(label2)
    }

    // MARK: - Cell Configuration
    func configure(model: Recommendations) {
        label1.text = model.name
        label2.text = model.artistName
        
        guard let url = URL(string: model.url) else {
            return
        }
        imageView.sd_setImage(with: url)
    }
}
