//
//  CharacterDetailAttributeSliderItemCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 19/07/22.
//

import UIKit

internal final class CharacterDetailAttributeSliderItemCell: UICollectionViewCell {
    internal static let nib = UINib(nibName: "CharacterDetailAttributeSliderItemCell", bundle: nil)
    internal static let identifier = "CharacterDetailAttributeSliderItemCell"

    @IBOutlet weak var imageView: OPImageView!
    @IBOutlet weak var label: UILabel!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.imageShape = .circle
        imageView.layer.borderWidth = 2.5
        imageView.layer.borderColor = UIColor.BB10.cgColor
    }
    
    internal func setupData(imageURL: URL?, label text: String) {
        imageView.url = imageURL
        label.attributedText = .display3(text, alignment: .center, textStyle: [.bold])
    }
}
