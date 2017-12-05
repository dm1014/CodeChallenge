//
//  SelectedViewController.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit
import CCCore

class SelectedViewController: UIViewController {
	fileprivate enum Constants {
		enum Sizes {
			static let spinner: CGFloat = 22.0
		}
	}
	
	fileprivate let spinner: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.hidesWhenStopped = true
		return view
	}()
	
	fileprivate let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0.0
		
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.showsHorizontalScrollIndicator = false
		view.backgroundColor = .white
		view.isPagingEnabled = true
		view.isHidden = true
		view.register(SelectedImageCell.self)
		return view
	}()

	
	fileprivate let images: [Image]
	fileprivate let selectedItem: Int
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	init(images: [Image], selectedItem: Int) {
		self.images = images
		self.selectedItem = selectedItem
		
		super.init(nibName: nil, bundle: nil)
		
		view.backgroundColor = .white
		
		setupViews()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
			self.collectionView.scrollToItem(at: IndexPath(item: self.selectedItem, section: 0), at: .centeredHorizontally, animated: false)
			self.collectionView.isHidden = false
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupViews() {
		view.addSubview(spinner)
		view.addSubview(collectionView)
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		let spinnerWidth = spinner.widthAnchor.constraint(equalToConstant: Constants.Sizes.spinner)
		let spinnerHeight = spinner.heightAnchor.constraint(equalToConstant: Constants.Sizes.spinner)
		let spinnerCenterX = spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		let spinnerCenterY = spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		
		let collectionTop = collectionView.topAnchor.constraint(equalTo: view.topAnchor)
		let collectionLeft = collectionView.leftAnchor.constraint(equalTo: view.leftAnchor)
		let collectionRight = collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
		let collectionBottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		
		NSLayoutConstraint.activate([spinnerWidth, spinnerHeight, spinnerCenterX, spinnerCenterY,
									 collectionTop, collectionLeft, collectionRight, collectionBottom])
		
		spinner.startAnimating()
	}
}

extension SelectedViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCell.reuseIdentifier, for: indexPath) as? SelectedImageCell else { return UICollectionViewCell() }
		
		cell.image = images[indexPath.row]
		
		return cell
	}
}

extension SelectedViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return collectionView.bounds.size
	}
}
