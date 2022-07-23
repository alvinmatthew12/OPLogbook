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
            return max((self.bounds.size.width / 2), 0)
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
    
    public var hideDefaultImage: Bool = false {
        didSet {
            if hideDefaultImage {
                imageView.image = nil
            }
        }
    }
    
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
    }
    
    private func setup() {
        setupView()
        
        if let imageName = imageName {
            setLocalImage(imageName)
        } else if let url = url {
            fetchImage(url: url)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                if self.hideDefaultImage == false {
                    self.imageName = OPImageView.brokenImageName
                }
                self.shimmerView.removeFromSuperview()
            }
        }
    }
    
    private func setupView() {
        setupCornerRadius()
        
        if imageView.isDescendant(of: self) == false {
            imageView.fixInView(self)
        }
        if shimmerView.isDescendant(of: self) == false {
            shimmerView.layer.zPosition = -1
            shimmerView.fixInView(self)
        }
    }
    
    private func setLocalImage(_ imageName: String) {
        if imageName == OPImageView.brokenImageName {
            imageView.contentMode = .scaleAspectFit
            backgroundColor = UIColor(hexaRGB: "D8D8D8")
        }
        imageView.image = UIImage(named: imageName)
        shimmerView.removeFromSuperview()
    }
    
    public func fetchImage(url: URL?, setAutomatically: Bool = true, onSuccess: ((RetrieveImageResult) -> Void)? = nil) {
        guard isFetchingImage == false else { return }
        isFetchingImage = true
        
        let result = KF.url(url)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { [weak self, onSuccess] result in
                self?.isFetchingImage = false
                self?.shimmerView.removeFromSuperview()
                onSuccess?(result)
            }
            .onFailure { [weak self] error in
                self?.isFetchingImage = false
                if self?.hideDefaultImage == false {
                    self?.imageName = OPImageView.brokenImageName
                }
                self?.shimmerView.removeFromSuperview()
            }
        
        if setAutomatically {
            result.set(to: imageView)
        } else {
            result.set(to: UIImageView())
        }
    }
    
    public func loadAndCrop(image: UIImage? = nil, url: URL? = nil, targetSize: CGSize) {
        setupView()
        isFetchingImage = false
        if let image = image {
            let resizedImage = image.crop(to: targetSize)
            imageView.image = resizedImage
            shimmerView.removeFromSuperview()
        } else if let url = url {
            fetchImage(url: url, setAutomatically: false) { [imageView] result in
                let image = result.image
                let resizedImage = image.crop(to: targetSize)
                imageView.image = resizedImage
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                if self.hideDefaultImage == false {
                    self.imageName = OPImageView.brokenImageName
                }
                self.shimmerView.removeFromSuperview()
            }
        }
    }
    
    private func setupCornerRadius() {
        self.clipsToBounds = true
        self.layer.cornerRadius = imageCornerRadius
    }
}
