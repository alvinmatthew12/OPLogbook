//
//  UIColor+Extension.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

extension UIColor {
    public static var darkModeEnabled: Bool {
        return UITraitCollection.current.userInterfaceStyle == .dark
    }
    
    public convenience init(light: UIColor, dark: UIColor) {
        if UIColor.darkModeEnabled {
            self.init(cgColor: dark.cgColor)
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
    
    public convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(
            red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
            green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
            blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
            alpha: alpha
        )
    }
}
