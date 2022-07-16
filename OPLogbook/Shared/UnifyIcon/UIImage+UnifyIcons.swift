//
//  UIImage+UnifyIcons.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

extension UIImage {
    public convenience init?(unifyIcon: UnifyIcon, color: UIColor? = nil) {
        guard let newImage = UIImage(named: unifyIcon.fileName)?.withRenderingMode(.alwaysTemplate) else {
            assertionFailure("icon \(unifyIcon.rawValue) is nout found in unify icon collection")
            return nil
        }
        
        let defaultColor: UIColor? = unifyIcon.color
        
        func generateOverridenTintColorCGImage(color withColor: UIColor? = nil) -> CGImage? {
            let imageFrame = CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height)
            
            UIGraphicsBeginImageContextWithOptions(newImage.size, false, newImage.scale)
            
            if let overrideColor = withColor {
                overrideColor.set()
            }
            
            newImage.draw(in: imageFrame)
            
            let modifiedTintColorImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            guard let finalImage = modifiedTintColorImage,
                  let finalCGImage = finalImage.cgImage
            else { return nil }
            
            return finalCGImage
        }
        
        if let overrideColor = color ?? defaultColor {
            guard let newColoredCGImage = generateOverridenTintColorCGImage(color: overrideColor) else { return nil }
            
            self.init(cgImage: newColoredCGImage, scale: newImage.scale, orientation: newImage.imageOrientation)
        } else {
            guard let originalCGImage = newImage.cgImage else { return nil }
            self.init(cgImage: originalCGImage, scale: newImage.scale, orientation: newImage.imageOrientation)
        }
        
    }
}
