//
//  Typography+Size.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 18/07/22.
//

import UIKit

extension TypographyType {
    internal var isHeading: Bool {
        if case .heading1 = self { return true }
        if case .heading2 = self { return true }
        if case .heading3 = self { return true }
        return false
    }
}

extension String {
    internal func getSize(_ type: TypographyType, _ textStyle: [TypographyStyle] = []) -> CGSize {
        let typographyAttributes = Typography.getAttributes(type: type)
        let fontFamily = (textStyle.contains(.bold) || type.isHeading) ?
            TypographyConstant.helveticeNeueBold : TypographyConstant.helveticeNeue
        let currentFont = fontFamily.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: .BW50,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: .left,
            strikethrough: textStyle.contains(.strikethrough)
        )
        let size = self.size(withAttributes: attributes)
        return size
    }
    
    public func widthOfString(_ attributedString: NSAttributedString) -> CGFloat {
        let attributes = attributedString.attributes(at: 0, effectiveRange: nil)
        let size = self.size(withAttributes: attributes)
        return size.width
    }
    
    public func heightOfString(_ attributedString: NSAttributedString) -> CGFloat {
        let attributes = attributedString.attributes(at: 0, effectiveRange: nil)
        let size = self.size(withAttributes: attributes)
        return size.height
    }
    
    public func widthOfString(_ type: TypographyType, textStyle: [TypographyStyle] = []) -> CGFloat {
        let size = getSize(type, textStyle)
        return size.width
    }
    
    public func heightOfString(_ type: TypographyType, textStyle: [TypographyStyle] = []) -> CGFloat {
        let size = getSize(type, textStyle)
        return size.height
    }
    
}
