//
//  CharacterDetailImageCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal final class CharacterDetailImageCell: CharacterDetailBaseCell {
    internal static let identifier = "CharacterDetailImageCell"
    
    internal let imageView = OPImageView()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.fixInView(self)
        contentView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
