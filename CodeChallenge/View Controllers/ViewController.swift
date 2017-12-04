//
//  ViewController.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import UIKit

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
		view.alpha = 1.0
		view.register(ImageCell.self)
		return view
	}()
	
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
	}
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 50
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
		
		cell.imageURL = "https://tse2.mm.bing.net/th?id=OIP.LMSqGg7LKzsYtAHB5sQ8zQEtDP&pid=Api"
		
		return cell
	}
}

