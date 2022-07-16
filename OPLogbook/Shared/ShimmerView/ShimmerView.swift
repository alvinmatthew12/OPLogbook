//
//  ShimmerView.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

public class ShimmerView: UIView {
    private var gradientLayer = CAGradientLayer()
    
    private var gradientColorOne = UIColor(white: 0.85, alpha: 1.0).cgColor
    private var gradientColorTwo = UIColor(white: 0.95, alpha: 1.0).cgColor
    private let keyPath = "locations"
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        addAnimations()
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            addAnimations()
        } else {
            removeAnimations()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = self.bounds
        CATransaction.commit()
    }
    
    private func addAnimations() {
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.15, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.15)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.1, 1.3, 1.5]
        animation.duration = 1.0
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientLayer.add(animation, forKey: keyPath)
    }
    
    private func removeAnimations() {
        gradientLayer.removeAllAnimations()
    }
}
