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
    @IBOutlet private weak var collectionView: UICollectionView!
    internal var selectedCell: CharacterListItemCell?
    internal var selectedCellImageViewSnapshot: UIView?
    internal var animator: CharacterPageAnimator?
    
    private let disposeBag = DisposeBag()
    private let viewModel: CharacterListViewModel
    private var characters: [Character] = []
    
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
        
        setupBarButton()
        setupCollectionView()
        bindViewModel()
    }
    
    private func setupBarButton() {
        let menusButton = OPButton(title: "", mode: .image(.init(unifyIcon: .menus)), size: .micro)
        let searchButton = OPButton(title: "", mode: .image(.init(unifyIcon: .search)), size: .micro)
        navigationItem.leftBarButtonItem = menusButton.toBarButtonItem()
        navigationItem.rightBarButtonItem = searchButton.toBarButtonItem()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .BB30
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 25
        layout.sectionInset = UIEdgeInsets(top: 16, left: 30, bottom: 0, right: 30)
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView.register(CharacterListItemCell.nib, forCellWithReuseIdentifier: CharacterListItemCell.identifier)
    }
    
    private func bindViewModel() {
        let input = CharacterListViewModel.Input(
            didLoadTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.characters
            .drive(onNext: { [weak self] characters in
                self?.characters = characters
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.networkError
            .drive(onNext: { [weak self] error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentDetailController(_ characterID: String) {
        let vc = CharacterDetailViewController(id: characterID)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension CharacterListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let character = characters[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterListItemCell.identifier, for: indexPath) as? CharacterListItemCell {
            cell.setupData(character)
            return cell
        }
        return UICollectionViewCell()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.size.width
        let padding: CGFloat = 30 + 12.5 // LR padding + interitem spacing
        let itemWidth: CGFloat = (width / 2) - padding
        let itemHeight: CGFloat = itemWidth + 35
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CharacterListItemCell {
            selectedCell = cell
            selectedCellImageViewSnapshot = cell.imageView.snapshotView(afterScreenUpdates: false)
        }
        let character = characters[indexPath.item]
        presentDetailController(character.id)
    }
}
