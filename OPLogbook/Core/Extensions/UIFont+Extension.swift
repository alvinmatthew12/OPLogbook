//
//  UIFont+Extension.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

extension UIFont {
    public enum FontStyle {
        case bold
        case italic
    }
    
    public static func primaryFont(size: CGFloat, style: [FontStyle] = []) -> UIFont {
        var name = "Helvetica Neue"
        var defaultValue = UIFont.systemFont(ofSize: size)
        if style.contains(.bold) {
            name += " Bold"
            defaultValue = UIFont.boldSystemFont(ofSize: size)
        }
        if style.contains(.italic) {
            name += " Italic"
            defaultValue = UIFont.italicSystemFont(ofSize: size)
        }
        return UIFont(name: name, size: size) ?? defaultValue
    }
}
