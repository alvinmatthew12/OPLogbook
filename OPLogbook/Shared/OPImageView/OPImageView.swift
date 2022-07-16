//
//  OPImageView.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit
import Kingfisher

public class OPImageView: UIView {
    private let imageView = UIImageView()
    private let shimmerView = ShimmerView()
    
    public var url: URL? {
        didSet {
            if isVisible {
                fetchImage(url: url)
            }
        }
    }
    
    public var image: UIImage? {
        didSet {
            if isVisible {
                setLocalImage(image)
            }
        }
    }
    
    public var imageShape: DisplayRadius = .none {
        didSet {
            if isVisible {
                setupCornerRadius()
            }
        }
    }
    
    private var calculatedSize: CGSize {
        isVisible ? self.bounds.size : CGSize.zero
    }
    
    private var imageCornerRadius: CGFloat {
        switch imageShape {
        case .circle:
            return max(calculatedSize.width, 0)
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .scaleAspectFit
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        contentMode = .scaleAspectFit
    }
    
    private var isFetchingImage: Bool = false {
        didSet {
            guard isFetchingImage != oldValue else { return }
            configShimmerView()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        imageView.fixInView(self)
        setupCornerRadius()
        
        if let image = image {
            setLocalImage(image)
        } else if let url = url {
            fetchImage(url: url)
        }
    }
    
    private func setLocalImage(_ image: UIImage?) {
        imageView.image = image
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
            }
            .onFailure { [weak self] error in
                self?.isFetchingImage = false
            }
            .set(to: imageView)
    }
    
    private func setupCornerRadius() {
        self.clipsToBounds = true
        self.layer.cornerRadius = imageCornerRadius
    }
    
    private func configShimmerView() {
        if isFetchingImage {
            shimmerView.layer.zPosition = -1
            shimmerView.fixInView(self)
        } else {
            shimmerView.removeFromSuperview()
        }
    }
}
