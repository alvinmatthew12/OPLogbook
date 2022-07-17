//
//  CharacterDetailNameCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal final class CharacterDetailNameCell: CharacterDetailBaseCell {
    internal static let nib = UINib(nibName: "CharacterDetailNameCell", bundle: nil)
    internal static let identifier = "CharacterDetailNameCell"
    
    @IBOutlet private weak var epithetLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var affiliationImageView: OPImageView!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        affiliationImageView.imageShape = .rect(cornerRadius: 6)
        affiliationImageView.backgroundColor = .BB10
    }
    
    internal func setupData(_ epithet: String, _ name: String, _ affiliationImageName: String) {
        epithetLabel.attributedText = .display1(epithet, color: .GY50, textStyle: [.bold])
        nameLabel.attributedText = .heading1(name)
        affiliationImageView.imageName = affiliationImageName
    }
}
