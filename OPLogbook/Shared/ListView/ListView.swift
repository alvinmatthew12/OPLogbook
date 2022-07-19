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

public final class ListView<C: Equatable>: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    public typealias RegisterCells = (() -> [ReuseableCell])?
    public typealias CustomizableLayout = ((_ item: C) -> ListViewLayout)?
    public typealias CellForItemAt = ((
        _ collectionView: UICollectionView,
        _ indexPath: IndexPath,
        _ item: C
    ) -> ListViewCell?)?
    
    public let defaultCellIdentifier = "default"
    
    public struct ReuseableCell {
        public let cellClass: AnyClass?
        public let nib: UINib?
        public let identifier: String
        
        public init(_ cellClass: AnyClass? = nil, nib: UINib? = nil, forCellWithReuseIdentifier: String) {
            self.cellClass = cellClass
            self.nib = nib
            self.identifier = forCellWithReuseIdentifier
        }
    }
    
    private struct CollectionData {
        internal let components: [C]
        internal let margins: UIEdgeInsets
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
    
    private var registerCells: RegisterCells
    private var customizableLayout: CustomizableLayout
    private var cellForItemAt: CellForItemAt
    
    private var collectionData: [CollectionData] = []
    
    public init(registerCells: RegisterCells, customizableLayout: CustomizableLayout = nil, _ cellForItemAt: CellForItemAt) {
        self.registerCells = registerCells
        self.customizableLayout = customizableLayout
        self.cellForItemAt = cellForItemAt
        super.init(frame: .zero)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        registerCells = nil
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
        
        let cells = registerCells?() ?? []
        for cell in cells {
            if let cellClass = cell.cellClass {
                collectionView.register(cellClass, forCellWithReuseIdentifier: cell.identifier)
            } else if let nib = cell.nib {
                collectionView.register(nib, forCellWithReuseIdentifier: cell.identifier)
            }
        }
    }
    
    public func performUpdates(_ components: [C]) {
        var collectionData: [CollectionData] = []
        
        var staggeredItem: [C] = []
        var staggeredFirstMargin: UIEdgeInsets = .zero
        
        func appendStaggeredItems() {
            collectionData.append(.init(components: staggeredItem, margins: staggeredFirstMargin))
            staggeredItem = []
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
                if staggeredItem.isEmpty {
                    staggeredFirstMargin = _margins
                }
                staggeredItem.append(component)
                if let nextComponent = components[safe: i + 1],
                   case .staggered = customizableLayout?(nextComponent) { } else {
                    appendStaggeredItems()
                }
                
            case .none: break
            }
        }
        
        if staggeredItem.isNotEmpty {
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
        if let cell = cellForItemAt?(collectionView, indexPath, item) {
            cell.layout = customizableLayout?(item)
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellIdentifier, for: indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionData[section].margins
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
}
