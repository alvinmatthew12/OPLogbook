//
//  Character.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

internal struct Character: Decodable, Equatable {
    internal let id: String
    internal let name: String
    internal let nickname: String
    internal let epithet: String
    internal let bounty: Double
    internal let birthday: String
    internal let origin: String
    internal let description: String
    internal let affiliation: CharacterAffiliation
    internal let attributes: [CharacterAttribute]
    private let _color: String
    @FailableDecodable
    internal var imageURL: URL?
    @FailableDecodable
    internal var backgroundURL: URL?
    
    internal var color: UIColor {
        UIColor(hexaRGB: _color) ?? .BB10
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, nickname,
             epithet, bounty, birthday,
             origin, description, affiliation,
             attributes
        case _color = "color"
        case imageURL = "image_url"
        case backgroundURL = "background_url"
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

internal struct CharacterAttribute: Decodable, Equatable {
    internal enum AttributeType: String, Decodable, Equatable {
        case tile
        case slider
    }
    
    @FailableDecodable
    internal var type: AttributeType?
    internal let title: String
    internal let items: [CharacterAttributeItem]
}

internal struct CharacterAttributeItem: Decodable, Equatable {
    @FailableDecodable
    internal var imageURL: URL?
    internal let title: String
    internal let shortDescription: String
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case title
        case shortDescription = "short_description"
    }
}
