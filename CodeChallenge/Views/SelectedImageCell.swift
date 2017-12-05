//
//  SelectedImageCell.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit
import CCCore

class SelectedImageCell: UICollectionViewCell {
	fileprivate enum Constants {
		enum Edges {
			static let description = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 8.0, right: 16.0)
		}
		enum Sizes {
			static let description: CGFloat = 32.0
			static let spinner: CGFloat = 22.0
		}
	}
	
	fileprivate let imageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleAspectFit
		return view
	}()
	
	fileprivate let descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		return label
	}()
	
	fileprivate let spinner: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.hidesWhenStopped = true
		return view
	}()
	
	open var image: Image? {
		didSet {
			guard let image = image, let url = URL(string: image.contentUrl) else { return }
			
			descriptionLabel.text = image.name
			ImageLoader.loadImage(from: url) { [weak self] (image) in
				guard let weakSelf = self, let image = image else { return }
				weakSelf.imageView.image = image
				weakSelf.imageView.isHidden = false
				weakSelf.spinner.stopAnimating()
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .white
		
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupViews() {
		contentView.addSubview(spinner)
		contentView.addSubview(imageView)
		contentView.addSubview(descriptionLabel)
		
		let spinnerWidth = spinner.widthAnchor.constraint(equalToConstant: Constants.Sizes.spinner)
		let spinnerHeight = spinner.heightAnchor.constraint(equalToConstant: Constants.Sizes.spinner)
		let spinnerCenterX = spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
		let spinnerCenterY = spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		
		let imageTop = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
		let imageLeft = imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
		let imageRight = imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
		let imageBottom = imageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor)
		
		let descriptionLeft = descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.Edges.description.left)
		let descriptionRight = descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.Edges.description.right)
		let descriptionHeight = descriptionLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.description)
		let descriptionBottom = descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Edges.description.bottom)
		
		NSLayoutConstraint.activate([spinnerWidth, spinnerHeight, spinnerCenterX, spinnerCenterY,
									 imageTop, imageLeft, imageRight, imageBottom,
									 descriptionLeft, descriptionRight, descriptionHeight, descriptionBottom])

		spinner.startAnimating()
	}
	
	override func prepareForReuse() {
		image = nil
		descriptionLabel.text = nil
		imageView.image = nil
		
		super.prepareForReuse()
	}
}
