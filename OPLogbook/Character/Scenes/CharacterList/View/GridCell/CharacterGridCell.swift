//
//  CharacterGridCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

internal final class CharacterGridCell: UICollectionViewCell {
    internal static let nib = UINib(nibName: "CharacterGridCell", bundle: nil)
    internal static let identifier = "CharacterGridCell"
    
    @IBOutlet weak var imageView: OPImageView!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        imageView.imageShape = .rect(cornerRadius: 12)
    }
    
    internal func setupData(_ data: Character) {
        imageView.url = URL(string: data.images.gridURL)
    }
}
