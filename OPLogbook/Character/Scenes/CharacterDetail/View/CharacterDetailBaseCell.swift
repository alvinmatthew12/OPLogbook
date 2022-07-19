//
//  CharacterDetailBaseCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal class CharacterDetailBaseCell: UICollectionViewCell {
    internal var layout: CharacterDetailComponent.Layout? {
        didSet { setNeedsLayout() }
    }
    
    override internal func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var width = UIScreen.main.bounds.width
        
        switch layout {
        case let .fullWidth(margins, _):
            let totalMargin: CGFloat = margins.left + margins.right
            width = width - totalMargin

        case let .staggered(margins, interItemSpacing, _):
            let totalMargin: CGFloat = max(margins.left, margins.right)
            let interItemHalf = max((interItemSpacing / 2), 0)
            width = (width / 2) - interItemHalf - totalMargin

        case .none:
            break
        }
        
        var frame = layoutAttributes.frame
        frame.size.width = width
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
}
