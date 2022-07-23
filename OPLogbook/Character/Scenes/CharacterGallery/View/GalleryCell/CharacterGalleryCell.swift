//
//  CharacterGalleryCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 23/07/22.
//

import UIKit

internal struct CharacterGalleryData {
    internal let imageURL: URL?
    internal let backgroundURL: URL?
}

internal final class CharacterGalleryCell: UICollectionViewCell {
    internal static var identifier = String(describing: CharacterGalleryCell.self)
    
    private let imageView = OPImageView()
    private let backgroundImageView = OPImageView()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImageView.hideDefaultImage = true
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
        setupCharacterImage(data.imageURL)
        backgroundImageView.url = data.backgroundURL
    }
    
    private func setupCharacterImage(_ url: URL?) {
        OPImageView().fetchImage(url: url, setAutomatically: false) { [weak self] result in
            guard let self = self else { return }
            let width = self.bounds.width
            let delta = width - 375
            let height = result.image.size.height + delta
            
            let contentHeight = self.bounds.height / 1.25
            if height > contentHeight {
                self.imageView.contentMode = .top
            } else {
                self.imageView.contentMode = .center
            }
            self.imageView.loadAndCrop(url: url, targetSize: CGSize(width: width, height: height))
        }
    }
}
