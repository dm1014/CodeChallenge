//
//  RootFlowController.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit

class RootFlowController {
	let viewController: ViewController
	
	init() {
		self.viewController = ViewController()
		self.viewController.flowController = self
	}
	
	public func presentSelectedImage() {

	}

}
