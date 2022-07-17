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
}

extension CharacterDetailComponent {
    internal enum Layout {
        case fullWidth(height: CGFloat = 0)
        case staggered(height: CGFloat = 0)
    }
    
    internal var layout: Layout{
        switch self {
        case .image:
            return .fullWidth(height: 270)
        case .name:
            return .fullWidth(height: 78)
        }
    }
}
