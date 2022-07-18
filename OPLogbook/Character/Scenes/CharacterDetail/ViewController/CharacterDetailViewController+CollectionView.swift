//
//  CharacterDetailViewController+CollectionView.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

extension CharacterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    internal func registerCell(_ collectionView: UICollectionView) {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        collectionView.register(CharacterDetailImageCell.self, forCellWithReuseIdentifier: CharacterDetailImageCell.identifier)
        collectionView.register(CharacterDetailNameCell.nib, forCellWithReuseIdentifier: CharacterDetailNameCell.identifier)
        collectionView.register(CharacterDetailDescriptionCell.self, forCellWithReuseIdentifier: CharacterDetailDescriptionCell.identifier)
        collectionView.register(CharacterDetailVStackTileCell.nib, forCellWithReuseIdentifier: CharacterDetailVStackTileCell.identifier)
        collectionView.register(CharacterDetailLabelCell.self, forCellWithReuseIdentifier: CharacterDetailLabelCell.identifier)
        collectionView.register(CharacterDetailAttributeTileCell.nib, forCellWithReuseIdentifier: CharacterDetailAttributeTileCell.identifier)
    }
    
    internal func performUpdates(_ components: [CharacterDetailComponent]) {
        var collectionData: [CollectionData] = []
        
        var staggeredItem: [CharacterDetailComponent] = []
        var staggeredFirstMargin: UIEdgeInsets = .zero
        
        for i in 0..<components.count {
            let component = components[i]
            switch component.layout {
            case let .fullWidth(_, margins, _):
                collectionData.append(.init(components: [component], margins: margins))
                
            case let .dynamicText(_, margins, _):
                collectionData.append(.init(components: [component], margins: margins))
                
            case let .staggered(_, margins, _, _):
                if staggeredItem.isEmpty {
                    staggeredFirstMargin = margins
                }
                staggeredItem.append(component)
                if case .staggered = components[safe: i + 1]?.layout { } else {
                    collectionData.append(.init(components: staggeredItem, margins: staggeredFirstMargin))
                    staggeredItem = []
                    staggeredFirstMargin = .zero
                }
            }
        }
        
        self.collectionData = collectionData
        self.collectionView.reloadData()
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionData.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData[section].components.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let component = collectionData[indexPath.section].components[indexPath.item]
        
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
            
        case let .vStackTile(label, value):
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailVStackTileCell.identifier, for: indexPath) as? CharacterDetailVStackTileCell {
                cell.setup(label: label, value: value)
                return cell
            }
            
        case let .label(attributedString):
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailLabelCell.identifier, for: indexPath) as? CharacterDetailLabelCell {
                cell.label.attributedText = attributedString
                return cell
            }
            
        case let .attributeTile(data):
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailAttributeTileCell.identifier, for: indexPath) as? CharacterDetailAttributeTileCell {
                cell.setupData(data)
                return cell
            }
            
        case .spacing:
            break
            
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionData[section].margins
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let component = collectionData[indexPath.section].components[indexPath.item]
        
        let width = collectionView.frame.size.width
        
        switch component.layout {
        case let .fullWidth(height, margins, lineSpacing):
            let totalMargin: CGFloat = margins.left + margins.right
            let _width = width - totalMargin
            let _height = height + lineSpacing
            return CGSize(width: _width, height: _height)
            
        case let .staggered(height, margins, interItemSpacing, lineSpacing):
            let totalMargin: CGFloat = max(margins.left, margins.right)
            let interItemHalf = max((interItemSpacing / 2), 0)
            let _width = (width / 2) - interItemHalf - totalMargin
            let _height = height + lineSpacing
            return CGSize(width: _width, height: _height)
            
        case let .dynamicText(attributedText, margins, lineSpacing):
            let textWidth = attributedText.size().width
            let textHeight: CGFloat = attributedText.heightOfString()
            let totalMargin: CGFloat = margins.left + margins.right
            
            let widthWithPadding = width - totalMargin
            
            let deltaWidth = textWidth / widthWithPadding
            var multiply = ceil(deltaWidth)
            if (deltaWidth - floor(deltaWidth) > 0.000001) { // check has decimal
                multiply += 1
            }
            
            let containerHeight = max((textHeight * multiply), 50)
            let height = containerHeight + lineSpacing
            
            let _width = width - totalMargin
            return CGSize(width: _width, height: height)
        }
    }
}
