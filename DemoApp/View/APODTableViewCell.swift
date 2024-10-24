//
//  APODModel.swift
//  DemoApp
//
//  Created by Apple on 23/10/2024.
//

import UIKit

class APODTableViewCell: UITableViewCell {
    
    let apodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 40 // Assuming image size will be 80x80
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill // Proper scaling for the image
        return imageView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0 // Allows multiline titles
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(apodImageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(titleLabel)
        
        // Set constraints for image, activity indicator, and title
        NSLayoutConstraint.activate([
            // ImageView constraints
            apodImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            apodImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            apodImageView.widthAnchor.constraint(equalToConstant: 80),
            apodImageView.heightAnchor.constraint(equalToConstant: 80),
            apodImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            // Activity Indicator constraints (centered inside the image view)
            activityIndicator.centerXAnchor.constraint(equalTo: apodImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: apodImageView.centerYAnchor),
            
            // TitleLabel constraints
            titleLabel.leadingAnchor.constraint(equalTo: apodImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: apodImageView.centerYAnchor),  // Align title with the image
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Start loading animation
    func startLoading() {
        activityIndicator.startAnimating()
        apodImageView.image = nil // Clear the image while loading
    }
    
    // Stop loading animation and set image
    func stopLoading(with image: UIImage?) {
        activityIndicator.stopAnimating()
        apodImageView.image = image
    }
}

