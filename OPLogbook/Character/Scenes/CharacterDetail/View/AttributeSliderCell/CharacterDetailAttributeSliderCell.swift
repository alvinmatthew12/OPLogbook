//
//  CharacterDetailAttributeSliderCell.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 19/07/22.
//

import UIKit

internal final class CharacterDetailAttributeSliderCell: ListViewCell {
    internal static let identifier = "CharacterDetailAttributeSliderCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .BB30
        return collectionView
    }()
    
    internal var items: [CharacterAttributeItem] = []
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        contentView.heightAnchor.constraint(equalToConstant: 115).isActive = true
        
        collectionView.fixInView(self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        collectionView.register(CharacterDetailAttributeSliderItemCell.nib, forCellWithReuseIdentifier: CharacterDetailAttributeSliderItemCell.identifier)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func navigateTo() {
        UIApplication.topViewController()?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}

extension CharacterDetailAttributeSliderCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailAttributeSliderItemCell.identifier, for: indexPath) as? CharacterDetailAttributeSliderItemCell {
            cell.setupData(imageURL: item.imageURL, label: item.title)
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateTo()
    }
}
