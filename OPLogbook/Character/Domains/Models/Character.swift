//
//  Character.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import Foundation

internal struct Character: Decodable, Equatable {
    internal let id: String
    internal let name: String
    internal let epithet: String
    internal let bounty: Double
    internal let shortDescription: String
    internal let affiliation: CharacterAffiliation
    internal let images: CharacterImages
    
    private enum CodingKeys: String, CodingKey {
        case id, name, epithet,
             bounty, affiliation, images
        case shortDescription = "short_description"
    }
}

internal struct CharacterAffiliation: Decodable, Equatable {
    internal let id: String
    internal let name: String
    internal let imageName: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case imageName = "image_name"
    }
}

internal struct CharacterImages: Decodable, Equatable {
    internal let gridImageName: String
    internal let pageImageName: String
    
    private enum CodingKeys: String, CodingKey {
        case gridImageName = "grid_image_name"
        case pageImageName = "page_image_name"
    }
}
