//
//  ListView.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 19/07/22.
//

import UIKit

public enum ListViewLayout {
    case fullWidth(margins: UIEdgeInsets = .zero, lineSpacing: CGFloat = 0)
    case staggered(margins: UIEdgeInsets = .zero, interItemSpacing: CGFloat = 0, lineSpacing: CGFloat = 0)
}

public struct ListViewReuseableCell {
    public let cellClass: AnyClass?
    public let nib: UINib?
    public let identifier: String
    
    public init(_ cellClass: AnyClass? = nil, identifier: String) {
        self.init(cellClass, nil, identifier: identifier)
    }
    
    public init(_ nib: UINib? = nil, identifier: String) {
        self.init(nil, nib, identifier: identifier)
    }
    
    internal init(_ cellClass: AnyClass? = nil, _ nib: UINib? = nil, identifier: String) {
        self.cellClass = cellClass
        self.nib = nib
        self.identifier = identifier
    }
}

public final class ListView<T: Equatable>: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    public typealias CustomizableLayout = ((_ item: T) -> ListViewLayout)?
    public typealias CellForItemAt = ((
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ item: T
    ) -> ListViewCell?)?
    
    private let listViewCellIdentifier = String(describing: ListViewCell.self)
    public let defaultCellIdentifier = "default"
    
    private struct CollectionData {
        internal let components: [T?]
        internal let margins: UIEdgeInsets
        internal var isPlaceholder: Bool = false
    }
    
    public let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    public var didScroll: ((_ scrollView: UIScrollView) -> Void)?
    public var didSelectItemAt: ((_ item: T) -> Void)?
    
    private var registerCells: [ListViewReuseableCell]
    private var customizableLayout: CustomizableLayout
    private var cellForItemAt: CellForItemAt
    
    private var collectionData: [CollectionData] = []
    
    public init(registerCells: [ListViewReuseableCell], customizableLayout: CustomizableLayout = nil, _ cellForItemAt: CellForItemAt) {
        self.registerCells = registerCells
        self.customizableLayout = customizableLayout
        self.cellForItemAt = cellForItemAt
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        registerCells = []
        customizableLayout = nil
        cellForItemAt = nil
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        collectionView.fixInView(self)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        registeringCells()
    }
    
    private func registeringCells() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultCellIdentifier)
        collectionView.register(ListViewCell.self, forCellWithReuseIdentifier: listViewCellIdentifier)
        for cell in registerCells {
            if let cellClass = cell.cellClass {
                collectionView.register(cellClass, forCellWithReuseIdentifier: cell.identifier)
            } else if let nib = cell.nib {
                collectionView.register(nib, forCellWithReuseIdentifier: cell.identifier)
            }
        }
    }
    
    public func performUpdates(_ components: [T]) {
        var collectionData: [CollectionData] = []
        
        var staggeredItems: [T?] = []
        var staggeredFirstMargin: UIEdgeInsets = .zero
        
        func appendStaggeredItems() {
            // To add blank item for staggered view that not complete the full width
            if staggeredItems.count < 2 {
                staggeredItems.append(nil)
            }
            collectionData.append(.init(components: staggeredItems, margins: staggeredFirstMargin))
            staggeredItems = []
            staggeredFirstMargin = .zero
        }
        
        for i in 0..<components.count {
            let component = components[i]
            let layout = customizableLayout?(component)
            
            switch layout {
            case let .fullWidth(margins, lineSpacing):
                var _margins = margins
                _margins.bottom = max(lineSpacing, 0.1)
                collectionData.append(.init(components: [component], margins: _margins))
                
            case let .staggered(margins, _, lineSpacing):
                var _margins = margins
                _margins.bottom = max(lineSpacing, 0.1)
                if staggeredItems.isEmpty {
                    staggeredFirstMargin = _margins
                }
                staggeredItems.append(component)
                
                if staggeredItems.count > 1 {
                    appendStaggeredItems()
                }
                
                if let nextComponent = components[safe: i + 1],
                   case .fullWidth = customizableLayout?(nextComponent) {
                    appendStaggeredItems()
                }
                
            case .none:
                collectionData.append(.init(components: [component], margins: .zero))
            }
        }
        
        if staggeredItems.isNotEmpty {
            appendStaggeredItems()
        }
        
        self.collectionData = collectionData
        self.collectionView.reloadData()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData[section].components.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionData[indexPath.section].components[indexPath.item]
        if let item = item, let cell = cellForItemAt?(collectionView, indexPath, item) {
            cell.layout = customizableLayout?(item)
            return cell
        } else {
            // Filling staggerd layout
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listViewCellIdentifier, for: indexPath) as? ListViewCell {
                if let previousItem = collectionData[indexPath.section].components[safe: indexPath.item - 1],
                   let item = previousItem,
                   let previousLayout = customizableLayout?(item) {
                    cell.layout = previousLayout
                    return cell
                }
            }
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellIdentifier, for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionData[section].margins
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = collectionData[indexPath.section]
        if let item = data.components[indexPath.item] {
            didSelectItemAt?(item)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
}
