//
//  CharacterDetailViewController+CollectionView.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

extension CharacterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return components.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let component = components[indexPath.item]
        
        switch component {
        case let .image(url):
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailImageCell.identifier, for: indexPath) as? CharacterDetailImageCell {
                cell.imageView.url = url
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
//    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let component = components[indexPath.item]
//        return 0
//    }
}
