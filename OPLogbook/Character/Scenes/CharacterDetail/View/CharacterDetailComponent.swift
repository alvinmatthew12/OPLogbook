//
//  CharacterDetailComponent.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal enum CharacterDetailComponent: Equatable {
    case image(URL?, UIColor)
    case name(_ epithet: String, _ name: String, _ affiliationImageName: String)
    case description(String)
    case vStackTile(label: String, value: String)
    case label(NSAttributedString)
    case attributeTile(CharacterAttributeItem)
    case attributeSlider([CharacterAttributeItem])
}
