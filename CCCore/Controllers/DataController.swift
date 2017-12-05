//
//  DataController.swift
//  CCCore
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation

public class DataController {
	fileprivate enum Constants {
		enum Keys {
			static let values = "value"
		}
	}
	
	class func parseSearchResponse(_ json: [String: Any]) throws -> [Image]? {
		var images: [Image] = []
		
		guard let values = json[Constants.Keys.values] as? [[String: Any]] else { return nil }
		try values.forEach { value in
			let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
			let image = try JSONDecoder().decode(Image.self, from: data)
			images.append(image)
		}
		return images
	}
}
