//
//  UnifyIcon.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

public enum UnifyIcon: String, Equatable {
    case chevronLeft
    case chevronRight
    case menus
    case search
}

extension UnifyIcon {
    public var fileName: String {
        switch self {
        case .chevronLeft:
            return "ic-chevron-left"
        case .chevronRight:
            return "ic-chevron-right"
        case .menus:
            return "ic-menus"
        case .search:
            return "ic-search"
        }
    }
    
    public var color: UIColor? {
        return .GY50
    }
}
