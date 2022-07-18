//
//  OPImageView.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit
import Kingfisher

public class OPImageView: UIView {
    public static let brokenImageName = "broken-image"
    public static let brokenImage = UIImage(named: "broken-image")
    
    private let imageView = UIImageView()
    private let shimmerView = ShimmerView()
    
    public var url: URL? {
        didSet {
            setup()
        }
    }
    
    public var imageName: String? {
        didSet {
            setup()
        }
    }
    
    public var imageShape: DisplayRadius = .none {
        didSet {
            setupCornerRadius()
        }
    }
    
    private var imageCornerRadius: CGFloat {
        switch imageShape {
        case .circle:
            return max(self.bounds.size.width, 0)
        case let .rect(cornerRadius):
            return cornerRadius
        case .none:
            return 0
        }
    }
    
    override public var contentMode: UIView.ContentMode {
        didSet {
            imageView.contentMode = contentMode
        }
    }
    
    override public var clipsToBounds: Bool {
        didSet {
            imageView.clipsToBounds = clipsToBounds
        }
    }
    
    private var isFetchingImage: Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .scaleAspectFit
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        contentMode = .scaleAspectFit
    }
    
    private func setup() {
        setupCornerRadius()
        
        if imageView.isDescendant(of: self) == false {
            imageView.fixInView(self)
        }
        if shimmerView.isDescendant(of: self) == false {
            shimmerView.layer.zPosition = -1
            shimmerView.fixInView(self)
        }
        
        if let imageName = imageName {
            setLocalImage(imageName)
        } else if let url = url {
            fetchImage(url: url)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.imageName = OPImageView.brokenImageName
            }
        }
    }
    
    private func setLocalImage(_ imageName: String) {
        imageView.image = UIImage(named: imageName)
        shimmerView.removeFromSuperview()
    }
    
    private func fetchImage(url: URL?) {
        guard isFetchingImage == false else { return }
        isFetchingImage = true
        
        KF.url(url)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { [weak self] result in
                self?.isFetchingImage = false
                self?.shimmerView.removeFromSuperview()
            }
            .onFailure { [weak self] error in
                self?.isFetchingImage = false
                self?.imageName = OPImageView.brokenImageName
            }
            .set(to: imageView)
    }
    
    private func setupCornerRadius() {
        self.clipsToBounds = true
        self.layer.cornerRadius = imageCornerRadius
    }
}
