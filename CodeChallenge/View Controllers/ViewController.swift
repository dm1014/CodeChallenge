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
			static let cell: CGFloat = UIScreen.main.bounds.width / 3.0
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
		view.alpha = 0.0
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

