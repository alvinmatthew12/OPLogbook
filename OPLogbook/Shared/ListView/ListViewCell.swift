//
//  ListViewCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 19/07/22.
//

import UIKit

open class ListViewCell: UICollectionViewCell {
    internal var layout: ListViewLayout? {
        didSet { setNeedsLayout() }
    }
    
    override open func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
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
