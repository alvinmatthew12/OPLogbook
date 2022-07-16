//
//  OPImageView+Extension.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

extension OPImageView {
    public enum DisplayRadius {
        case circle
        case rect(cornerRadius: CGFloat)
        case none
    }
    
    public enum DisplayLoading {
        case blur
        case shimmer
        case none
    }
}
