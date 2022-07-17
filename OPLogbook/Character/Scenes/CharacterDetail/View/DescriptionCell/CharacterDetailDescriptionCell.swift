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
        label.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
