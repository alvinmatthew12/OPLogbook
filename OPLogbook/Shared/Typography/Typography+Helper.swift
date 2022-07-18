//
//  Typography+Helper.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 18/07/22.
//

import UIKit

extension Typography {
    public static func getAttributes(type: TypographyType) -> TypographyAttribute {
        switch type {
        case .heading1:
            return TypographyAttribute(size: TypographyConstant.heading1Size, lineHeight: TypographyConstant.heading1LineHeight)
        case .heading2:
            return TypographyAttribute(size: TypographyConstant.heading2Size, lineHeight: TypographyConstant.heading2LineHeight)
        case .heading3:
            return TypographyAttribute(size: TypographyConstant.heading3Size, lineHeight: TypographyConstant.heading3LineHeight)
        case .display1:
            return TypographyAttribute(size: TypographyConstant.display1Size, lineHeight: TypographyConstant.display1LineHeight)
        case .display2:
            return TypographyAttribute(size: TypographyConstant.display2Size, lineHeight: TypographyConstant.display2LineHeight)
        case .display3:
            return TypographyAttribute(size: TypographyConstant.display3Size, lineHeight: TypographyConstant.display3LineHeight)
        case .paragraph1:
            return TypographyAttribute(size: TypographyConstant.display1Size, lineHeight: TypographyConstant.paragraph1LineHeight)
        case .paragraph2:
            return TypographyAttribute(size: TypographyConstant.display2Size, lineHeight: TypographyConstant.paragraph2LineHeight)
        case .paragraph3:
            return TypographyAttribute(size: TypographyConstant.display3Size, lineHeight: TypographyConstant.paragraph3LineHeight)
        case .small:
            return TypographyAttribute(size: TypographyConstant.smallSize, lineHeight: TypographyConstant.smallLineHeight)
        }
    }
    
    internal static func getLineSpacing(font: UIFont, lineHeight: CGFloat) -> CGFloat {
        let defaultLineHeight = font.lineHeight
        return lineHeight - defaultLineHeight
    }
}
