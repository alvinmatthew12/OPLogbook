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
            return TypographyAttribute(size: TypographyConstant.heading1Size, lineSpacing: TypographyConstant.heading1LineSpacing)
        case .heading2:
            return TypographyAttribute(size: TypographyConstant.heading2Size, lineSpacing: TypographyConstant.heading2LineSpacing)
        case .heading3:
            return TypographyAttribute(size: TypographyConstant.heading3Size, lineSpacing: TypographyConstant.heading3LineSpacing)
        case .display1:
            return TypographyAttribute(size: TypographyConstant.display1Size, lineSpacing: TypographyConstant.display1LineSpacing)
        case .display2:
            return TypographyAttribute(size: TypographyConstant.display2Size, lineSpacing: TypographyConstant.display2LineSpacing)
        case .display3:
            return TypographyAttribute(size: TypographyConstant.display3Size, lineSpacing: TypographyConstant.display3LineSpacing)
        case .paragraph1:
            return TypographyAttribute(size: TypographyConstant.display1Size, lineSpacing: TypographyConstant.paragraph1LineSpacing)
        case .paragraph2:
            return TypographyAttribute(size: TypographyConstant.display2Size, lineSpacing: TypographyConstant.paragraph2LineSpacing)
        case .paragraph3:
            return TypographyAttribute(size: TypographyConstant.display3Size, lineSpacing: TypographyConstant.paragraph3LineSpacing)
        case .small:
            return TypographyAttribute(size: TypographyConstant.smallSize, lineSpacing: TypographyConstant.smallLineSpacing)
        }
    }
    
    internal static func getLineSpacing(font: UIFont, lineSpacing: CGFloat) -> CGFloat {
        let defaultLineHeight = font.lineHeight
        return lineSpacing - defaultLineHeight
    }
}
