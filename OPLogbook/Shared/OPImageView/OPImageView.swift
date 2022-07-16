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
    
    private var isFetchingImage: Bool = false
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        if let image = image {
            setLocalImage(image)
        } else {
            fetchImage(url: url)
        }
        setupCornerRadius()
    }
    
    private func setLocalImage(_ image: UIImage?) {
        imageView.image = image
        setupImageViewSize()
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
              self?.setupImageViewSize()
          }
          .onFailure { [weak self] error in
              self?.isFetchingImage = false
          }
          .set(to: imageView)
    }
    
    private func setupImageViewSize() {
        addSubview(imageView)
        imageView.frame = self.frame
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupCornerRadius() {
        self.clipsToBounds = true
        self.layer.cornerRadius = imageCornerRadius
    }
}
