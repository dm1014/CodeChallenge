//
//  NetworkController.swift
//  CodeChallenge
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation

class NetworkController {
	fileprivate enum Constants {
		enum Endpoints {
			static let base = "https://api.cognitive.microsoft.com/bing/v5.0/images/search"
		}
		
		enum Headers {
			static let subscriptionKey = "Ocp-Apim-Subscription-Key"
			static let subscriptionValue = "5db7a77b19d943f2a4cce83ce6b59502"
		}
		
		enum Parameters {
			static let query = "q"
			static let count = "count"
			static let offset = "offset"
		}
	}
	
	public static let shared = NetworkController()
	
	public func search(keyword: String, count: Int = 40, offset: Int = 0) {
		guard var components = URLComponents(string: Constants.Endpoints.base) else { return }
		
		let queryItem = URLQueryItem(name: Constants.Parameters.query, value: keyword)
		let countItem = URLQueryItem(name: Constants.Parameters.count, value: "\(count)")
		let offsetItem = URLQueryItem(name: Constants.Parameters.offset, value: "\(offset)")
		
		components.queryItems = [queryItem, countItem, offsetItem]
		components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
		
		guard let url = components.url else { return }
		
		var request = URLRequest(url: url)
		request.setValue(Constants.Headers.subscriptionValue, forHTTPHeaderField: Constants.Headers.subscriptionKey)
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let data = data, let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode < 400 , error == nil else { return }
			
			do {
				let object = try JSONSerialization.jsonObject(with: data) as? [String: Any]
				print(object)
			} catch {
				print(error)
			}
		}.resume()
	}
}
