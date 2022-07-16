//
//  CharacterDetailComponent.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal enum CharacterDetailComponent: Equatable {
    case image(URL?)
}

extension CharacterDetailComponent {
    internal enum Layout {
        case fullWidth(margins: UIEdgeInsets = .zero, lineSpacing: CGFloat = 0)
        case staggered(margins: UIEdgeInsets = .zero, interItemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0)
    }
    
    internal var layout: Layout{
        switch self {
        case .image:
            return .fullWidth(lineSpacing: 15)
        }
    }
}
