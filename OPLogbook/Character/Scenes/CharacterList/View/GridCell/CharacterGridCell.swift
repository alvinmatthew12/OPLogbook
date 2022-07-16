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
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
    }
    
    internal func setupData(_ data: Character) {
        imageView.image = UIImage(named: data.images.gridImageName)
    }
}
