//
//  ViewController.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import UIKit
import CCCore

class ViewController: UIViewController {

	fileprivate enum Constants {
		enum Animations {
			static let duration: TimeInterval = 0.2
		}
		
		enum Sizes {
			static let spinner: CGFloat = 22.0
			static let cell: CGFloat = UIScreen.main.bounds.width / 4.0
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
		layout.itemSize = CGSize(width: Constants.Sizes.cell, height: Constants.Sizes.cell)
		layout.minimumLineSpacing = 0.0
		layout.minimumInteritemSpacing = 0.0
		
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .white
		view.alpha = 0.0
		view.register(ImageCell.self)
		return view
	}()
	
	fileprivate var searchedImages: [Image] = []
	
	open var flowController: RootFlowController?
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		view.backgroundColor = .white
		title = "Revl Challenge"

		setupViews()
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
		
		NetworkController.shared.search(keyword: "kite surfing") { [weak self] (images, error) in
			DispatchQueue.main.async {
				guard let weakSelf = self, let images = images else { return }
				weakSelf.searchedImages = images
				weakSelf.collectionView.reloadData()
				weakSelf.collectionView.alpha = 1.0
				weakSelf.spinner.stopAnimating()
			}
		}
	}
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searchedImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
		
		let image = searchedImages[indexPath.row]
		cell.imageURL = image.thumbnailUrl
		
		return cell
	}
}

