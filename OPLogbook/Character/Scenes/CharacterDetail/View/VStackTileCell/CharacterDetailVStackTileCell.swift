//
//  CharacterDetailVStackTileCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 18/07/22.
//

import UIKit

internal final class CharacterDetailVStackTileCell: ListViewCell {
    internal static let nib = UINib(nibName: "CharacterDetailVStackTileCell", bundle: nil)
    internal static let identifier = "CharacterDetailVStackTileCell"
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var value: UILabel!
    
    internal func setup(label: String, value: String) {
        self.label.attributedText = .small(label)
        self.value.attributedText = .display1(value, textStyle: [.bold])
    }
}
