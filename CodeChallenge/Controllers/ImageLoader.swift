//
//  ImageLoader.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageLoader {
	
	class func loadImage(from url: URL, _ completion: @escaping (UIImage?) -> ()) {
		if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
			completion(cachedImage)
		} else {
			URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
				if error != nil {
					completion(nil)
				} else if let imageData = data, let downloadedImage = UIImage(data: imageData) {
					DispatchQueue.main.async {
						imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
						completion(downloadedImage)
					}
				} else {
					completion(nil)
				}
			}).resume()
		}
	}
}
