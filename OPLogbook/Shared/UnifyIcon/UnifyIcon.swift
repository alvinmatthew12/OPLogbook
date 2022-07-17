//
//  UnifyIcon.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

public enum UnifyIcon: String, Equatable {
    case carousel
    case grid
    case chevronLeft
}

extension UnifyIcon {
    public var fileName: String {
        switch self {
        case .carousel:
            return "ic-carousel"
        case .grid:
            return "ic-grid"
        case .chevronLeft:
            return "ic-chevron-left"
        }
    }
    
    public var color: UIColor? {
        switch self {
        case .carousel, .grid, .chevronLeft:
            return .primaryColor
        }
    }
}
