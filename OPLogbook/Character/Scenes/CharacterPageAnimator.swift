//
//  CharacterPageAnimator.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

internal final class CharacterPageAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    internal static let duration: TimeInterval = 1.25

    private let type: PresentationType
    private let listController: CharacterListViewController
    private let detailController: CharacterDetailViewController
    private let selectedCellImageViewSnapshot: UIView
    private let cellImageViewRect: CGRect
    
    internal init?(type: PresentationType, listController: CharacterListViewController, detailController: CharacterDetailViewController, selectedCellImageViewSnapshot: UIView) {
        self.type = type
        self.listController = listController
        self.detailController = detailController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        
            
            print("HAHAHA init")
        
        guard let window = listController.view.window ?? detailController.view.window,
            let selectedCell = listController.selectedCell
            else { return nil }
        
        if let gridCell = selectedCell as? CharacterGridCell {
            cellImageViewRect = gridCell.imageView.convert(gridCell.imageView.bounds, to: window)
        } else {
            cellImageViewRect = .zero
        }
    }
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = detailController.view else {
            transitionContext.completeTransition(false)
            return
        }

        containerView.addSubview(toView)
        
        guard let selectedCell = listController.selectedCell,
              let window = listController.view.window ?? detailController.view.window,
              let gridCell = selectedCell as? CharacterGridCell,
              let cellImageSnapshot = gridCell.imageView.snapshotView(afterScreenUpdates: true),
              let controllerImageSnapshot = detailController.imageView.snapshotView(afterScreenUpdates: true)
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let isPresenting = type.isPresenting
        
        let imageViewSnapshot: UIView

        if isPresenting {
            imageViewSnapshot = cellImageSnapshot
        } else {
            imageViewSnapshot = controllerImageSnapshot
        }
        
        
        toView.alpha = 0
        [imageViewSnapshot].forEach { containerView.addSubview($0) }
        
        let controllerImageViewRect = detailController.imageView.convert(detailController.imageView.bounds, to: window)
        
        [imageViewSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
        }
        
        
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                imageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
            }
        }, completion: { _ in
            imageViewSnapshot.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
    }
}

extension CharacterPageAnimator {
    internal enum PresentationType {
        case present
        case dismiss
        var isPresenting: Bool {
            return self == .present
        }
    }
}
