//
//  CharacterListItemCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal final class CharacterListItemCell: UICollectionViewCell {
    internal static let nib = UINib(nibName: "CharacterListItemCell", bundle: nil)
    internal static let identifier = "CharacterListItemCell"
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet internal weak var imageView: OPImageView!
    @IBOutlet private weak var label: UILabel!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 20
        imageView.imageShape = .rect(cornerRadius: 15)
        imageView.contentMode = .center
    }
    
    internal func setupData(_ data: Character) {
        imageView.backgroundColor = data.color
        imageView.loadAndCrop(url: data.imageURL, targetSize: CGSize(width: 375, height: 250))
        label.text = data.nickname
    }
}
