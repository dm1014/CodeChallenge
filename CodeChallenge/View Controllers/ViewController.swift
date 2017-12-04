//
//  ViewController.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	open var flowController: RootFlowController?
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Revl Challenge"
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		view.backgroundColor = .white
		
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupViews() {
		
	}

}

