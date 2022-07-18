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

extension NSAttributedString {
    public func widthOfString() -> CGFloat {
        let attributes = self.attributes(at: 0, effectiveRange: nil)
        let size = self.string.size(withAttributes: attributes)
        return size.width
    }
    
    public func heightOfString() -> CGFloat {
        var lineHeight: CGFloat = 0
        if let paragraphStyle = self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
            lineHeight = paragraphStyle.lineSpacing
        }
        let attributes = self.attributes(at: 0, effectiveRange: nil)
        let size = self.string.size(withAttributes: attributes)
        return size.height + lineHeight
    }
}
