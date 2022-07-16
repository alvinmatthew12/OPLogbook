//
//  CharacterPageCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import RxCocoa
import RxSwift
import UIKit

internal final class CharacterPageCell: UICollectionViewCell {
    internal static let nib = UINib(nibName: "CharacterPageCell", bundle: nil)
    internal static let identifier = "CharacterPageCell"

    @IBOutlet private weak var imageView: OPImageView!
    @IBOutlet private weak var epithetLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var affiliationContainerView: UIView!
    @IBOutlet private weak var affiliationImageView: UIImageView!
    @IBOutlet private weak var bountyLabel: UILabel!
    @IBOutlet private weak var exploreButton: OPButton!
    @IBOutlet private weak var shortDescription: UILabel!
    
    internal var disposeBag = DisposeBag()
    internal var didTapExploreButton: (() -> Void)?
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        affiliationContainerView.clipsToBounds = true
        affiliationContainerView.layer.cornerRadius = 8
        shortDescription.textColor = .typographyColor
        
        exploreButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.didTapExploreButton?()
            })
            .disposed(by: disposeBag)
    }
    
    internal func setupData(_ data: Character) {
        imageView.url = data.images.pageURL
        epithetLabel.text = data.epithet
        nameLabel.text = data.name
        affiliationImageView.image = UIImage(named: data.affiliation.imageName)
        bountyLabel.text = data.bounty.currencyDecimalFormat
        shortDescription.text = data.shortDescription
    }
}
