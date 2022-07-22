//
//  CharacterDetailLabelCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 19/07/22.
//

import UIKit

internal final class CharacterDetailLabelCell: ListViewCell {
    internal static let identifier = String(describing: CharacterDetailLabelCell.self)
    internal static let reusableCell = ListViewReuseableCell(
        CharacterDetailLabelCell.self,
        identifier: CharacterDetailLabelCell.identifier
    )
    
    internal let label = UILabel()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        label.fixInView(self)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
