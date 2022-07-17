//
//  OPButton.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

public final class OPButton: UIButton {
    
    public var title: String {
        didSet {
            guard title != oldValue else { return }
            accessibilityLabel = title
            configButton()
        }
    }
    
    override public var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else { return }
            buttonState = isEnabled ? .normal : .disabled
        }
    }
    
    public var isLoading: Bool = false {
        didSet {
            guard isLoading != oldValue else { return }
            buttonState = isLoading ? .loading : .normal
        }
    }
    
    public var buttonState: ButtonState = .normal {
        didSet {
            configButtonState()
        }
    }
    
    public var mode: Mode {
        didSet {
            guard mode != oldValue else { return }
            configButton()
        }
    }
    
    public var size: Size {
        didSet {
            guard size != oldValue else { return }
            configButton()
        }
    }
    
    private lazy var activityIndicator = createActivityIndicator()
    
    public init(
        title: String,
        mode: Mode = .fill,
        size: Size = .medium
    ) {
        self.title = title
        self.mode = mode
        self.size = size
        
        super.init(frame: .zero)
        configButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.title = ""
        self.mode = .fill
        self.size = .medium
        
        super.init(coder: aDecoder)
        
        title = titleLabel?.text ?? ""
        configButton()
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    private func configButton() {
        setTitle(title, for: .normal)
        titleLabel?.font = .primaryFont(size: size.fontSize, style: [.bold])
        layer.cornerRadius = size.cornerRadius
        frame.size.height = size.height
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        switch mode {
        case .fill:
            backgroundColor = .TL10
            setTitleColor(.white, for: .normal)
        case .ghost:
            backgroundColor = UIColor.clear
            layer.borderWidth = 1
            layer.borderColor = UIColor.TL10.cgColor
            setTitleColor(.BW50, for: .normal)
        case .text:
            backgroundColor = UIColor.clear
            setTitleColor(.BW50, for: .normal)
        case let .image(image):
            backgroundColor = UIColor.clear
            setBackgroundImage(image, for: .normal)
            contentMode = .scaleAspectFit
            widthAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    private func configButtonState() {
        switch buttonState {
        case .normal:
            alpha = 1
            isUserInteractionEnabled = true
            setTitle(title, for: .normal)
            activityIndicator.stopAnimating()
        case .loading:
            guard buttonState != .disabled else { return }
            isUserInteractionEnabled = false
            setTitle("", for: .normal)
            startAnimatingActivityIndicator()
        case .disabled:
            alpha = 0.3
            isUserInteractionEnabled = true
            setTitle(title, for: .normal)
            activityIndicator.stopAnimating()
        }
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.GY50
        return activityIndicator
    }

    private func startAnimatingActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
