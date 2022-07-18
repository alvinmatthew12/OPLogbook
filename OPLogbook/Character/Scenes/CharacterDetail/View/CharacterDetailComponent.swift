//
//  CharacterDetailComponent.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal enum CharacterDetailComponent: Equatable {
    case image(URL?)
    case name(_ epithet: String, _ name: String, _ affiliationImageName: String)
    case description(String)
    case vStackTile(label: String, value: String)
//    case header(NSAttributedString)
    case spacing(CGFloat)
}

extension CharacterDetailComponent {
    internal enum Layout {
        case fullWidth(height: CGFloat, margins: UIEdgeInsets = .zero, lineSpacing: CGFloat = 0)
        case staggered(height: CGFloat, margins: UIEdgeInsets = .zero, interItemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0)
        case dynamicText(NSAttributedString,margins: UIEdgeInsets = .zero,lineSpacing: CGFloat = 0)
    }
    
    internal var layout: Layout{
        let defaultMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        switch self {
        case .image:
            return .fullWidth(height: 250, lineSpacing: 20)
        case .name:
            return .fullWidth(height: 48, margins: defaultMargins, lineSpacing: 30)
        case let .description(text):
            return .dynamicText(
                .paragraph2(text, alignment: .justified),
                margins: defaultMargins,
                lineSpacing: 30
            )
        case .vStackTile:
            return .staggered(
                height: 32,
                margins: defaultMargins,
                interItemSpacing: 10,
                lineSpacing: 15
            )
//        case let .header:
//            return .fullWidth(height: <#T##CGFloat#>, margins: <#T##UIEdgeInsets#>, lineSpacing: <#T##CGFloat#>)
        case let .spacing(height):
            return .fullWidth(height: height)
        }
    }
}
