//
//  RootFlowController.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit
import CCCore

class RootFlowController {
	let viewController: ViewController
	
	init() {
		self.viewController = ViewController()
		self.viewController.flowController = self
	}
	
	public func presentSelectedImage(images: [Image], selectedItem: Int) {
		guard let navController = viewController.navigationController else { return }

		let selectedVC = SelectedViewController(images: images, selectedItem: selectedItem)
		navController.pushViewController(selectedVC, animated: true)
	}

}
