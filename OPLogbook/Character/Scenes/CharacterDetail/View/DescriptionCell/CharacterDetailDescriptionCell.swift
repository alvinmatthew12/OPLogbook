//
//  CharacterDetailDescriptionCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 18/07/22.
//

import UIKit

internal final class CharacterDetailDescriptionCell: UICollectionViewCell {
    internal static let identifier = "CharacterDetailDescriptionCell"
    
    internal let label = UILabel()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        label.fixInView(self.contentView, attributes: [.top, .leading, .trailing])
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
