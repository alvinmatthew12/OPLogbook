//
//  UIButton+BarButtonItem.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

extension UIButton {
    public func toBarButtonItem() -> UIBarButtonItem? {
        let barButton = UIBarButtonItem(customView: self)
        let height = CGFloat(max(Int(self.frame.size.height), 24))
        barButton.customView?.widthAnchor.constraint(equalToConstant: height).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        return barButton
    }
}
