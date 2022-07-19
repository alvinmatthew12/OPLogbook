////
////  CharacterDetailViewController+CollectionView.swift
////  OPLogbook
////
////  Created by Alvin Matthew Pratama on 17/07/22.
////
//
//import UIKit
//
//extension CharacterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    internal func registerCell(_ collectionView: UICollectionView) {
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
//        collectionView.register(CharacterDetailImageCell.self, forCellWithReuseIdentifier: CharacterDetailImageCell.identifier)
//        collectionView.register(CharacterDetailNameCell.nib, forCellWithReuseIdentifier: CharacterDetailNameCell.identifier)
//        collectionView.register(CharacterDetailDescriptionCell.self, forCellWithReuseIdentifier: CharacterDetailDescriptionCell.identifier)
//        collectionView.register(CharacterDetailVStackTileCell.nib, forCellWithReuseIdentifier: CharacterDetailVStackTileCell.identifier)
//        collectionView.register(CharacterDetailLabelCell.self, forCellWithReuseIdentifier: CharacterDetailLabelCell.identifier)
//        collectionView.register(CharacterDetailAttributeTileCell.nib, forCellWithReuseIdentifier: CharacterDetailAttributeTileCell.identifier)
//        collectionView.register(CharacterDetailAttributeSliderCell.self, forCellWithReuseIdentifier: CharacterDetailAttributeSliderCell.identifier)
//    }
//
//    internal func performUpdates(_ components: [CharacterDetailComponent]) {
//        var collectionData: [CollectionData] = []
//
//        var staggeredItem: [CharacterDetailComponent] = []
//        var staggeredFirstMargin: UIEdgeInsets = .zero
//
//        for i in 0..<components.count {
//            let component = components[i]
//            switch component.layout {
//            case let .fullWidth(margins, lineSpacing):
//                var _margins = margins
//                _margins.bottom = max(lineSpacing, 0.1)
//                collectionData.append(.init(components: [component], margins: _margins))
//
//            case let .staggered(margins, _, lineSpacing):
//                var _margins = margins
//                _margins.bottom = lineSpacing
//                if staggeredItem.isEmpty {
//                    staggeredFirstMargin = _margins
//                }
//                staggeredItem.append(component)
//                if case .staggered = components[safe: i + 1]?.layout { } else {
//                    collectionData.append(.init(components: staggeredItem, margins: staggeredFirstMargin))
//                    staggeredItem = []
//                    staggeredFirstMargin = .zero
//                }
//            }
//        }
//
//        self.collectionData = collectionData
//        self.collectionView.reloadData()
//    }
//
//    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return collectionData.count
//    }
//
//    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return collectionData[section].components.count
//    }
//
//    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let component = collectionData[indexPath.section].components[indexPath.item]
//
//        switch component {
//        case let .image(url):
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailImageCell.identifier, for: indexPath) as? CharacterDetailImageCell {
//                cell.layout = component.layout
//                cell.imageView.url = url
//                return cell
//            }
//
//        case let .name(epithet, name, affiliationImageName):
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailNameCell.identifier, for: indexPath) as? CharacterDetailNameCell {
//                cell.layout = component.layout
//                cell.setupData(epithet, name, affiliationImageName)
//                return cell
//            }
//
//        case let .description(text):
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailDescriptionCell.identifier, for: indexPath) as? CharacterDetailDescriptionCell {
//                cell.layout = component.layout
//                cell.label.attributedText = .paragraph2(text, alignment: .justified)
//                return cell
//            }
//
//        case let .vStackTile(label, value):
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailVStackTileCell.identifier, for: indexPath) as? CharacterDetailVStackTileCell {
//                cell.layout = component.layout
//                cell.setup(label: label, value: value)
//                return cell
//            }
//
//        case let .label(attributedString):
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailLabelCell.identifier, for: indexPath) as? CharacterDetailLabelCell {
//                cell.layout = component.layout
//                cell.label.attributedText = attributedString
//                return cell
//            }
//
//        case let .attributeTile(data):
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailAttributeTileCell.identifier, for: indexPath) as? CharacterDetailAttributeTileCell {
//                cell.layout = component.layout
//                cell.setupData(data)
//                return cell
//            }
//
//        case let .attributeSlider(items):
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailAttributeSliderCell.identifier, for: indexPath) as? CharacterDetailAttributeSliderCell {
//                cell.layout = component.layout
//                cell.items = items
//                return cell
//            }
//
//        }
//
//        return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
//    }
//
//    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return collectionData[section].margins
//    }
//}
