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
}
