//
//  UIView+Extension.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

extension UIView {
    public var isVisible: Bool {
        _isVisible()
    }
    
    private func _isVisible() -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view: self, inView: self.superview)
    }
}
