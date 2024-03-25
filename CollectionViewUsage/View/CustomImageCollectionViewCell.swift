//
//  CustomImageCollectionViewCell.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 23.03.2024.
//

import UIKit

final class CustomImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomImageCollectionViewCell"
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        imageView.layer.cornerRadius = AppConstants.RadiusConstants.medium.rawValue
        imageView.layer.masksToBounds = true
    }
    
    required init?(coder aCoder: NSCoder) {
        fatalError("init(coder:) has been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
