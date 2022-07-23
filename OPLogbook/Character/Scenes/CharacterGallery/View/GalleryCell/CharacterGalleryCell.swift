//
//  CharacterGalleryCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 23/07/22.
//

import UIKit

internal struct CharacterGalleryData {
    internal var imageURL: URL?
    internal var backgroundURL: URL? = nil
    internal var contentMode: UIView.ContentMode? = nil
}

internal final class CharacterGalleryCell: UICollectionViewCell {
    internal static var identifier = String(describing: CharacterGalleryCell.self)
    
    private let imageView = OPImageView()
    private let backgroundImageView = OPImageView()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImageView.hideBrokenImage = true
        backgroundImageView.alpha = 0.3
        
        backgroundImageView.fixInView(self.contentView)
        imageView.fixInView(self.contentView)
        
        backgroundImageView.contentMode = .scaleAspectFill
        imageView.contentMode = .center
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func setupData(_ data: CharacterGalleryData) {
        setupCharacterImage(data.imageURL, data.contentMode)
        if let url = data.backgroundURL {
            backgroundImageView.url = url
        }
    }
    
    private func setupCharacterImage(_ url: URL?, _ contentMode: UIView.ContentMode?) {
        if let contentMode = contentMode {
            self.imageView.contentMode = contentMode
            self.imageView.url = url
            return
        }
        
        OPImageView().fetchImage(url: url, setAutomatically: false) { [weak self] result in
            guard let self = self else { return }
            
            let width = self.bounds.width
            let delta = width - 375
            let height = result.image.size.height + delta
            
            if let contentMode = contentMode {
                self.imageView.contentMode = contentMode
            } else {
                let contentHeight = self.bounds.height / 1.25
                if height > contentHeight {
                    self.imageView.contentMode = .top
                } else {
                    self.imageView.contentMode = .center
                }
            }
            
            self.imageView.loadAndCrop(image: result.image, targetSize: CGSize(width: width, height: height))
        }
    }
}
