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
			static let copied: Int = 2
		}
		
		enum Sizes {
			static let textField: CGFloat = 44.0
			static let spinner: CGFloat = 22.0
			static let footer: CGFloat = 54.0
			static let cell: CGFloat = UIScreen.main.bounds.width / 4.0
			static let queryCount = 60
			static let copiedContainer: CGFloat = 40.0
		}
	}
	
	fileprivate let textField: UITextField = {
		let field = UITextField()
		field.translatesAutoresizingMaskIntoConstraints = false
		field.font = UIFont.systemFont(ofSize: 24.0, weight: .light)
		field.placeholder = "Search something..."
		field.textAlignment = .center
		field.returnKeyType = .search
		return field
	}()
	
	fileprivate let spinner: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.hidesWhenStopped = true
		view.isHidden = true
		return view
	}()
	
	fileprivate let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: Constants.Sizes.cell, height: Constants.Sizes.cell)
		layout.minimumLineSpacing = 0.0
		layout.minimumInteritemSpacing = 0.0
		layout.footerReferenceSize = CGSize(width: 0.0, height: Constants.Sizes.footer)
		
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.showsVerticalScrollIndicator = false
		view.backgroundColor = .white
		view.alpha = 0.0
		view.register(ImageCell.self)
		view.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter)
		return view
	}()
	
	fileprivate let copiedContainer: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Themes.Colors.green
		return view
	}()
	
	fileprivate let copiedLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Copied!"
		label.font = UIFont.boldSystemFont(ofSize: 17.0)
		label.textColor = .white
		label.textAlignment = .center
		return label
	}()
	
	fileprivate var containerBottom = NSLayoutConstraint()
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
		view.addSubview(textField)
		view.addSubview(spinner)
		view.addSubview(collectionView)
		view.addSubview(copiedContainer)
		copiedContainer.addSubview(copiedLabel)
		
		textField.delegate = self
		collectionView.delegate = self
		collectionView.dataSource = self
		
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
		longPress.minimumPressDuration = 0.2
		longPress.delaysTouchesBegan = true
		collectionView.addGestureRecognizer(longPress)
		
		let textLeft = textField.leftAnchor.constraint(equalTo: view.leftAnchor)
		let textRight = textField.rightAnchor.constraint(equalTo: view.rightAnchor)
		let textHeight = textField.heightAnchor.constraint(equalToConstant: Constants.Sizes.textField)
		let textCenterY =  textField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		
		let spinnerWidth = spinner.widthAnchor.constraint(equalToConstant: Constants.Sizes.spinner)
		let spinnerHeight = spinner.heightAnchor.constraint(equalToConstant: Constants.Sizes.spinner)
		let spinnerCenterX = spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		let spinnerCenterY = spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		
		let collectionTop = collectionView.topAnchor.constraint(equalTo: view.topAnchor)
		let collectionLeft = collectionView.leftAnchor.constraint(equalTo: view.leftAnchor)
		let collectionRight = collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
		let collectionBottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		
		let containerLeft = copiedContainer.leftAnchor.constraint(equalTo: view.leftAnchor)
		let containerRight = copiedContainer.rightAnchor.constraint(equalTo: view.rightAnchor)
		let containerHeight = copiedContainer.heightAnchor.constraint(equalToConstant: Constants.Sizes.copiedContainer)
		containerBottom = copiedContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.Sizes.copiedContainer)
		
		let copiedTop = copiedLabel.topAnchor.constraint(equalTo: copiedContainer.topAnchor)
		let copiedLeft = copiedLabel.leftAnchor.constraint(equalTo: copiedContainer.leftAnchor)
		let copiedRight = copiedLabel.rightAnchor.constraint(equalTo: copiedContainer.rightAnchor)
		let copiedBottom = copiedLabel.bottomAnchor.constraint(equalTo: copiedContainer.bottomAnchor)
		
		NSLayoutConstraint.activate([textLeft, textRight, textHeight, textCenterY,
									 spinnerWidth, spinnerHeight, spinnerCenterX, spinnerCenterY,
									 collectionTop, collectionLeft, collectionRight, collectionBottom,
									 containerLeft, containerRight, containerHeight, containerBottom,
									 copiedTop, copiedLeft, copiedRight, copiedBottom])
		
	}
	
	@objc fileprivate func longPressAction(_ sender: UILongPressGestureRecognizer) {
		guard sender.state == .ended, let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)), let url = URL(string: searchedImages[indexPath.item].contentUrl) else { return }
		
		ImageLoader.loadImage(from: url) { (image) in
			UIPasteboard.general.image = image
			self.handleCopiedImage()
		}
	}
	
	fileprivate func handleCopiedImage() {
		view.layoutIfNeeded()
		UIView.animate(withDuration: Constants.Animations.duration, animations: {
			self.containerBottom.constant = 0.0
			self.view.layoutIfNeeded()
		}) { _ in
			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Constants.Animations.copied), execute: {
				self.view.layoutIfNeeded()
				UIView.animate(withDuration: Constants.Animations.duration, animations: {
					self.containerBottom.constant = Constants.Sizes.copiedContainer
					self.view.layoutIfNeeded()
				})
			})
		}
	}
}

extension ViewController {
	fileprivate func performSearch(keyword: String) {
		NetworkController.shared.search(keyword: keyword, offset: searchedImages.count) { [weak self] (images, error) in
			guard let weakSelf = self, let images = images else { return }
			DispatchQueue.main.async {
				weakSelf.searchedImages.append(contentsOf: images)
				weakSelf.collectionView.reloadData()
			}
		}
	}
}

extension ViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let text = textField.text else { return false }
		
		textField.resignFirstResponder()
		textField.isHidden = true
		spinner.isHidden = false
		spinner.startAnimating()
		searchedImages = []
		
		NetworkController.shared.search(keyword: text) { [weak self] (images, error) in
			DispatchQueue.main.async {
				guard let weakSelf = self, let images = images else { return }
				
				weakSelf.searchedImages = images
				weakSelf.collectionView.reloadData()
				
				UIView.animate(withDuration: Constants.Animations.duration, animations: {
					weakSelf.collectionView.alpha = 1.0
				}, completion: { _ in
					weakSelf.spinner.stopAnimating()
				})
			}
		}

		return true
	}
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searchedImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.row == searchedImages.count - 1 {
			performSearch(keyword: "kite surfing")
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
		
		let image = searchedImages[indexPath.row]
		cell.imageURL = image.thumbnailUrl
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard kind == UICollectionElementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: LoadingFooterView.reuseIdentifier, for: indexPath) as? LoadingFooterView else { return UICollectionReusableView() }
		return footer
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		flowController?.presentSelectedImage(images: searchedImages, selectedItem: indexPath.item)
	}
}

