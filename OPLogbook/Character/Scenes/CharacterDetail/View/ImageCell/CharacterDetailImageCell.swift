//
//  CharacterDetailImageCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal final class CharacterDetailImageCell: UICollectionViewCell {
    internal static let identifier = "CharacterDetailImageCell"
    
    internal let imageView = OPImageView()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.fixInView(self.contentView, attributes: [.top, .leading, .trailing])
        imageView.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
