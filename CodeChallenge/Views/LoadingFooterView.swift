//
//  LoadingFooterView.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit

class LoadingFooterView: UICollectionReusableView {
	fileprivate enum Constants {
		enum Sizes {
			static let spinner: CGFloat = 22.0
		}
	}
	
	fileprivate let spinner: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupViews() {
		addSubview(spinner)
		
		spinner.startAnimating()
		
		let spinnerWidth = spinner.widthAnchor.constraint(equalToConstant: Constants.Sizes.spinner)
		let spinnerHeight = spinner.heightAnchor.constraint(equalToConstant: Constants.Sizes.spinner)
		let spinnerCenterX = spinner.centerXAnchor.constraint(equalTo: centerXAnchor)
		let spinnerCenterY = spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
		
		NSLayoutConstraint.activate([spinnerWidth, spinnerHeight, spinnerCenterX, spinnerCenterY])
	}
}
