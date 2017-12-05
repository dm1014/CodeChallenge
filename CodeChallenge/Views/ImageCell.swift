//
//  ImageCell.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
	fileprivate enum Constants {
		enum Animations {
			static let duration: TimeInterval = 0.2
		}
	}
	
	fileprivate let imageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleAspectFill
		view.clipsToBounds = true
		view.alpha = 0.0
		return view
	}()
	
	open var imageURL: String? {
		didSet {
			guard let imageURL = imageURL, let url = URL(string: imageURL) else {
				imageView.isHidden = true
				return
			}

			imageView.isHidden = false
			ImageLoader.loadImage(from: url) { [weak self] (image) in
				guard let weakSelf = self else { return }
				if let img = image {
					weakSelf.imageView.image = img
					UIView.animate(withDuration: Constants.Animations.duration, animations: {
						weakSelf.imageView.alpha = 1.0
					})
				} else {
					weakSelf.imageView.isHidden = true
				}
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupViews() {
		contentView.addSubview(imageView)
		
		let imageTop = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
		let imageLeft = imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
		let imageRight = imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
		let imageBottom = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		
		NSLayoutConstraint.activate([imageTop, imageLeft, imageRight, imageBottom])
	}
	
	override func prepareForReuse() {
		self.imageURL = nil
		
		super.prepareForReuse()
	}
}
