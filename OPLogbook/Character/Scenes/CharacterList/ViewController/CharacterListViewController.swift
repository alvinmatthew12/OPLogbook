//
//  CharacterListViewController.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import RxCocoa
import RxSwift
import UIKit

internal final class CharacterListViewController: UIViewController {
    private lazy var listView = ListView<Character>(
        registerCells: [CharacterListItemCell.reusableCell],
        customizableLayout: { _ in .staggered(
            margins: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30),
            interItemSpacing: 25,
            lineSpacing: 25
        ) }
    ) { collectionView, indexPath, character in
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterListItemCell.identifier, for: indexPath) as? CharacterListItemCell {
            cell.setupData(character)
            return cell
        }
        return nil
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel: CharacterListViewModel
    
    internal init() {
        viewModel = CharacterListViewModel(useCase: .live)
        super.init(nibName: nil, bundle: nil)
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Characters"
        
        listView.fixInView(self.view)
        
        listView.didSelectItemAt = { [weak self] character in
            self?.navigateToDetail(character.id)
        }
        
        setupBarButton()
        bindViewModel()
    }
    
    private func setupBarButton() {
        let menusButton = OPButton(title: "", mode: .image(.init(unifyIcon: .menus)), size: .micro)
        let searchButton = OPButton(title: "", mode: .image(.init(unifyIcon: .search)), size: .micro)
        navigationItem.leftBarButtonItem = menusButton.toBarButtonItem()
        navigationItem.rightBarButtonItem = searchButton.toBarButtonItem()
    }
    
    private func bindViewModel() {
        let input = CharacterListViewModel.Input(
            didLoadTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.characters
            .drive(onNext: { [weak self] characters in
                self?.listView.performUpdates(characters)
            })
            .disposed(by: disposeBag)
        
        output.networkError
            .drive(onNext: { [weak self] error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToDetail(_ characterID: String) {
        let vc = CharacterDetailViewController(id: characterID)
        navigationController?.pushViewController(vc, animated: true)
    }
}
