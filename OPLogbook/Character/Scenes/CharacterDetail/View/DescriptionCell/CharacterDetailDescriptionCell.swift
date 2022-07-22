//
//  CharacterDetailDescriptionCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 18/07/22.
//

import UIKit

internal final class CharacterDetailDescriptionCell: ListViewCell {
    internal static let identifier = String(describing: CharacterDetailDescriptionCell.self)
    internal static let reusableCell = ListViewReuseableCell(
        CharacterDetailDescriptionCell.self,
        identifier: CharacterDetailDescriptionCell.identifier
    )
    
    internal let label = UILabel()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        label.fixInView(self.contentView)
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
