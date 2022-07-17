//
//  Typography.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 18/07/22.
//

import UIKit

internal final class Typography { }

extension NSAttributedString {
    internal static func setFont(
        font: UIFont,
        color: UIColor,
        lineSpacing: CGFloat,
        alignment: NSTextAlignment,
        strikethrough: Bool
    ) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        if strikethrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        return attributes
    }
    
    public static func heading1(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        strikethrough: Bool = false
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .heading1)
        let currentFont = TypographyConstant.helveticeNeueBold.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: strikethrough
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func heading2(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        strikethrough: Bool = false
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .heading2)
        let currentFont = TypographyConstant.helveticeNeueBold.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: strikethrough
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func heading3(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        strikethrough: Bool = false
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .heading3)
        let currentFont = TypographyConstant.helveticeNeueBold.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: strikethrough
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func display1(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        textStyle: [TypographyStyle] = []
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .display1)
        let fontFamily = textStyle.contains(.bold) ? TypographyConstant.helveticeNeueBold : TypographyConstant.helveticeNeue
        let currentFont = fontFamily.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: textStyle.contains(.strikethrough)
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func display2(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        textStyle: [TypographyStyle] = []
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .display2)
        let fontFamily = textStyle.contains(.bold) ? TypographyConstant.helveticeNeueBold : TypographyConstant.helveticeNeue
        let currentFont = fontFamily.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: textStyle.contains(.strikethrough)
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func display3(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        textStyle: [TypographyStyle] = []
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .display3)
        let fontFamily = textStyle.contains(.bold) ? TypographyConstant.helveticeNeueBold : TypographyConstant.helveticeNeue
        let currentFont = fontFamily.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: textStyle.contains(.strikethrough)
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func paragraph1(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        textStyle: [TypographyStyle] = []
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .paragraph1)
        let fontFamily = textStyle.contains(.bold) ? TypographyConstant.helveticeNeueBold : TypographyConstant.helveticeNeue
        let currentFont = fontFamily.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: textStyle.contains(.strikethrough)
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func paragraph2(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        textStyle: [TypographyStyle] = []
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .paragraph2)
        let fontFamily = textStyle.contains(.bold) ? TypographyConstant.helveticeNeueBold : TypographyConstant.helveticeNeue
        let currentFont = fontFamily.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: textStyle.contains(.strikethrough)
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func paragraph3(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        textStyle: [TypographyStyle] = []
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .paragraph3)
        let fontFamily = textStyle.contains(.bold) ? TypographyConstant.helveticeNeueBold : TypographyConstant.helveticeNeue
        let currentFont = fontFamily.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: textStyle.contains(.strikethrough)
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    public static func small(
        _ string: String,
        color: UIColor = .BW50,
        alignment: NSTextAlignment = .left,
        textStyle: [TypographyStyle] = []
    ) -> NSAttributedString {
        let typographyAttributes = Typography.getAttributes(type: .small)
        let fontFamily = textStyle.contains(.bold) ? TypographyConstant.helveticeNeueBold : TypographyConstant.helveticeNeue
        let currentFont = fontFamily.withSize(typographyAttributes.size)
        let attributes = NSAttributedString.setFont(
            font: currentFont,
            color: color,
            lineSpacing: Typography.getLineSpacing(font: currentFont, lineSpacing: typographyAttributes.lineSpacing),
            alignment: alignment,
            strikethrough: textStyle.contains(.strikethrough)
        )
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        return attributedString
    }
}
