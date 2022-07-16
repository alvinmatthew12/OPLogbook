//
//  UIColor+UnifyColors.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

extension UIColor {
    private static func getColorByName(_ colorName: String) -> UIColor {
        UIColor(named: colorName) ?? UIColor.black
    }
    
    public static var primaryColor: UIColor {
        getColorByName("primaryColor")
    }
    
    public static var grayColor: UIColor {
        getColorByName("grayColor")
    }
    
    public static var typographyColor: UIColor {
        getColorByName("typographyColor")
    }
    
    public static var baseWhite: UIColor {
        getColorByName("baseWhite")
    }
    
    public static var neutralColor: UIColor {
        getColorByName("neutralColor")
    }
}
