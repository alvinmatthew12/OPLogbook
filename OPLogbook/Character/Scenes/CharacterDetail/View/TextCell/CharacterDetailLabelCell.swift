//
//  CharacterDetailLabelCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 19/07/22.
//

import UIKit

internal final class CharacterDetailLabelCell: UICollectionViewCell {
    internal static let identifier = "CharacterDetailLabelCell"
    
    internal let label = UILabel()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        label.fixInView(self, attributes: [.top, .leading, .trailing])
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
