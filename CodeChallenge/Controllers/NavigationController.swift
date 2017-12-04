//
//  NavigationController.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if let topViewController = topViewController {
			return topViewController.preferredStatusBarStyle
		}
		
		return .default
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)
	}
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		self.navigationBar.barTintColor = Themes.Colors.blue
		self.navigationBar.tintColor = .white
		self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.navigationBar.isTranslucent = false
		self.navigationBar.shadowImage = UIImage()
		self.navigationBar.setBackgroundImage(UIImage(), for: .default)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
