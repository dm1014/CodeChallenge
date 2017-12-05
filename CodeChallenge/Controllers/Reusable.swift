//
//  Reusable.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable: class {
	static var reuseIdentifier: String { get }
}

extension Reusable {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

extension UICollectionViewCell: Reusable { }

extension UICollectionReusableView: Reusable { }

extension UICollectionView {
	func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
		register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
	}
	
	func register<T: UICollectionReusableView>(_ viewClass: T.Type, forSupplementaryViewOfKind kind: String) {
		register(viewClass.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewClass.reuseIdentifier)
	}
}
