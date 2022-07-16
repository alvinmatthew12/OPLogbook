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

extension UIView {
    public enum ConstraintAttribute {
        case all
        case top, bottom
        case leading, trailing
    }
    
    public func fixInView(_ container: UIView, toSafeArea: Bool = false, attributes: [ConstraintAttribute] = [.all]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.bounds
        container.addSubview(self)
        
        let toItem = toSafeArea ? container.safeAreaLayoutGuide : container
        
        if attributes.contains(.top) || attributes.contains(.all) {
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        }
        if attributes.contains(.bottom) || attributes.contains(.all) {
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        }
        if attributes.contains(.leading) || attributes.contains(.all) {
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: toItem, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        }
        if attributes.contains(.trailing) || attributes.contains(.all) {
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: toItem, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        }
    }
}
