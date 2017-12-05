//
//  Image.swift
//  CCCore
//
//  Created by David Martin on 12/4/17.
//  Copyright © 2017 dm Apps. All rights reserved.
//

import Foundation

public struct Image {
	public let name: String
	public let imageId: String
	public let thumbnailUrl: String
	public let contentUrl: String
	
	init(name: String, id: String, thumbnail: String, content: String) {
		self.name = name
		self.imageId = id
		self.thumbnailUrl = thumbnail
		self.contentUrl = content
	}
}

extension Image: Decodable {
	enum ImageKeys: String, CodingKey {
		case name = "name"
		case imageId = "imageId"
		case thumbnailUrl = "thumbnailUrl"
		case contentUrl = "contentUrl"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ImageKeys.self)
		let name = try container.decode(String.self, forKey: .name)
		let id = try container.decode(String.self, forKey: .imageId)
		let thumbnail = try container.decode(String.self, forKey: .thumbnailUrl)
		let content = try container.decode(String.self, forKey: .contentUrl)
		
		self.init(name: name, id: id, thumbnail: thumbnail, content: content)
	}
}
