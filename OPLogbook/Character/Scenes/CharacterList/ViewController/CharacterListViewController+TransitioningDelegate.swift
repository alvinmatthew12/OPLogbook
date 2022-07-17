//
//  CharacterListViewController+TransitioningDelegate.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import UIKit

extension CharacterListViewController: UIViewControllerTransitioningDelegate {
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let navigationController = presenting as? UINavigationController,
              let listController = navigationController.viewControllers.first(where: { $0 is CharacterListViewController }) as? CharacterListViewController,
              let detailController = presented as? CharacterDetailViewController,
              let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        else { return nil }
        
        animator = CharacterPageAnimator(type: .present, listController: listController, detailController: detailController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
    
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let detailController = dismissed as? CharacterDetailViewController,
              let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        else { return nil }

        animator = CharacterPageAnimator(type: .dismiss, listController: self, detailController: detailController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
}
