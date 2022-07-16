//
//  CharacterGridCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

internal final class CharacterGridCell: UICollectionViewCell {
    internal static let identifier = "CharacterGridCell"
    
    private let imageView: OPImageView = {
        let imageView = OPImageView()
        imageView.imageShape = .rect(cornerRadius: 12)
        return imageView
    }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        imageView.fixInView(self.contentView)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override internal func prepareForReuse() {
        super.prepareForReuse()
        imageView.url = nil
    }
    
    internal func setupData(_ data: Character) {
        imageView.url = URL(string: data.images.gridURL)
    }
}
