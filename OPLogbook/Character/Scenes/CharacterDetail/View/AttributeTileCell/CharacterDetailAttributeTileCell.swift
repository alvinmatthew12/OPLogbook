//
//  CharacterDetailAttributeTileCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 19/07/22.
//

import UIKit

internal final class CharacterDetailAttributeTileCell: UICollectionViewCell {
    internal static let nib = UINib(nibName: "CharacterDetailAttributeTileCell", bundle: nil)
    internal static let identifier = "CharacterDetailAttributeTileCell"

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: OPImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
        imageView.imageShape = .rect(cornerRadius: 12)
    }
    
    internal func setupData(_ data: CharacterAttributeItem) {
        imageView.url = data.imageURL
        titleLabel.attributedText = .display2(data.title, textStyle: [.bold])
        descriptionLabel.attributedText = .paragraph3(data.shortDescription)
    }
}
