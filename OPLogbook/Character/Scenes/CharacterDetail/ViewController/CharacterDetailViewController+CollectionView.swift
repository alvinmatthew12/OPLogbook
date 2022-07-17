//
//  CharacterDetailViewController+CollectionView.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

extension CharacterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    internal func registerCell(_ collectionView: UICollectionView) {
        collectionView.register(CharacterDetailImageCell.self, forCellWithReuseIdentifier: CharacterDetailImageCell.identifier)
        collectionView.register(CharacterDetailNameCell.nib, forCellWithReuseIdentifier: CharacterDetailNameCell.identifier)
        collectionView.register(CharacterDetailDescriptionCell.self, forCellWithReuseIdentifier: CharacterDetailDescriptionCell.identifier)
    }
    
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
            
        case let .name(epithet, name, affiliationImageName):
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailNameCell.identifier, for: indexPath) as? CharacterDetailNameCell {
                cell.setupData(epithet, name, affiliationImageName)
                return cell
            }
            
        case let .description(text):
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailDescriptionCell.identifier, for: indexPath) as? CharacterDetailDescriptionCell {
                cell.label.attributedText = .paragraph2(text, alignment: .justified)
                return cell
            }
            
        }
        
        return UICollectionViewCell()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let component = components[indexPath.item]
        
        let width = collectionView.frame.size.width
        
        switch component.layout {
        case let .fullWidth(height):
            return CGSize(width: width, height: height)
            
        case let .staggered(height):
            return CGSize(width: width / 2, height: height)
            
        case let .dynamicText(attributedText, textLineSpacing, totalMargin, lineSpacing):
            let textWidth = attributedText.size().width
            let textHeight: CGFloat = textLineSpacing
            let widthWithPadding = width - totalMargin
            
            let deltaWidth = textWidth / widthWithPadding
            var multiply = ceil(deltaWidth)
            if (deltaWidth - floor(deltaWidth) > 0.000001) { // check has decimal
                multiply += 1
            }
            
            let containerHeight = max((textHeight * multiply), 50)
            let height = containerHeight + lineSpacing
            
            return CGSize(width: width, height: height)
        }
    }
}
