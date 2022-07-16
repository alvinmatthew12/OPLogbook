//
//  OPButton+Extension.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

extension OPButton {
    public enum ButtonState: Equatable {
        case normal
        case loading
        case disabled
    }
    
    public enum Mode: Equatable {
        case fill
        case ghost
        case text
        case image(UIImage?)
    }
    
    public enum Size: Equatable {
        case large
        case medium
        case small
        case micro
        
        internal var height: CGFloat {
            switch self {
            case .large:
                return 48
            case .medium:
                return 40
            case .small:
                return 32
            case .micro:
                return 24
            }
        }
        
        internal var cornerRadius: CGFloat {
            switch self {
            case .large, .medium, .small:
                return 8
            case .micro:
                return 6
            }
        }
        
        internal var fontSize: CGFloat {
            switch self {
            case .large, .medium:
                return 16
            case .small, .micro:
                return 12
            }
        }
    }
}
