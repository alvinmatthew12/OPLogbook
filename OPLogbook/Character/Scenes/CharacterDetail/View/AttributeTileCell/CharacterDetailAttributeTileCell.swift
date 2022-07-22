//
//  CharacterDetailAttributeTileCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 19/07/22.
//

import RxCocoa
import RxSwift
import UIKit

internal final class CharacterDetailAttributeTileCell: ListViewCell {
    internal static let identifier = String(describing: CharacterDetailAttributeTileCell.self)
    internal static var reusableCell = ListViewReuseableCell(
        UINib(nibName: CharacterDetailAttributeTileCell.identifier, bundle: nil),
        identifier: CharacterDetailAttributeTileCell.identifier
    )

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: OPImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        containerView.layer.cornerRadius = 12
        imageView.imageShape = .rect(cornerRadius: 7)
        
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = true
        containerView.addGestureRecognizer(tap)
        containerView.isUserInteractionEnabled = true
        tap.rx.event.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigateTo()
            })
            .disposed(by: disposeBag)
    }
    
    internal func setupData(_ data: CharacterAttributeItem) {
        imageView.url = data.imageURL
        titleLabel.attributedText = .display2(data.title, textStyle: [.bold])
        descriptionLabel.attributedText = .paragraph3(data.shortDescription)
    }
    
    internal func navigateTo() {
        UIApplication.topViewController()?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
