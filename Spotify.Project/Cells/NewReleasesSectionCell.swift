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
    
    let label1: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let label2: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let label3: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // MARK: - Initialization
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupViews()
        }
        
        // MARK: - Setup Views
        private func setupViews() {
            contentView.addSubview(label1)
            contentView.addSubview(label2)
            contentView.addSubview(label3)
            
            setupConstraints()
        }
        
        // MARK: - Setup Constraints
        private func setupConstraints() {
            NSLayoutConstraint.activate([
                label1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                label1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                label1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                
                label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 10),
                label2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                label2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                
                label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10),
                label3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                label3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                label3.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }
        
        // MARK: - Cell Configuration
        func configure(label1Text: String, label2Text: String, label3Text: String) {
            label1.text = label1Text
            label2.text = label2Text
            label3.text = label3Text
        }
}
