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

extension CharacterDetailComponent {
    internal var customizableLayout: ListViewLayout {
        let defaultMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        switch self {
        case .image:
            return .fullWidth(lineSpacing: 20)
            
        case .name, .description:
            return .fullWidth(
                margins: defaultMargins,
                lineSpacing: 30
            )
            
        case .vStackTile:
            return .staggered(
                margins: defaultMargins,
                interItemSpacing: 10,
                lineSpacing: 15
            )
            
        case .label:
            return .fullWidth(
                margins: defaultMargins,
                lineSpacing: 0
            )
            
        case .attributeTile:
            return .fullWidth(
                margins: defaultMargins,
                lineSpacing: 15
            )
            
        case .attributeSlider:
            return .fullWidth(
                margins: .zero,
                lineSpacing: 15
            )
        }
    }
}
