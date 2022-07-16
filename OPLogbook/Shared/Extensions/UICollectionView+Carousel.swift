//
//  UICollectionLayout+Carousel.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import UIKit

public final class CarouselLayout: UICollectionViewFlowLayout {
    override public init() {
        super.init()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.scrollDirection = .horizontal
        self.sectionInset = .zero
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            itemSize = collectionView.frame.size
        }
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard itemSize != newBounds.size else { return false }
        itemSize = newBounds.size
        return true
    }
}

extension UICollectionView {
    open func setCarouselLayout(animated: Bool) {
        setCollectionViewLayout(CarouselLayout(), animated: animated)
    }
}
