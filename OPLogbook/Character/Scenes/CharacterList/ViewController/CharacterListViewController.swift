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
    private let layoutModeButton = OPButton(
        title: "",
        mode: .image(UIImage(unifyIcon: .carousel)),
        size: .micro
    )
    
    private let disposeBag = DisposeBag()
    private let viewModel: CharacterListViewModel
    private var tempCharacters: [Character] = []
    private var characters: [Character] = []
    private var isGridMode: Bool = false {
        didSet { updateContentMode() }
    }
    
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
        navigationItem.rightBarButtonItem = layoutModeButton.toBarButtonItem()
        
        setupCollectionView()
        bindViewModel()
        setupRedux()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        setupCollectionLayout()
        
        collectionView.register(CharacterGridCell.nib, forCellWithReuseIdentifier: CharacterGridCell.identifier)
        collectionView.register(CharacterPageCell.nib, forCellWithReuseIdentifier: CharacterPageCell.identifier)
    }
    
    private func bindViewModel() {
        let input = CharacterListViewModel.Input(
            didLoadTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.characters
            .drive(onNext: { [weak self] characters in
                self?.tempCharacters = characters
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
    
    private func setupRedux() {
        layoutModeButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.isGridMode.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateContentMode() {
        characters = []
        collectionView.reloadData()
        setupCollectionLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            self.characters = self.tempCharacters
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionLayout() {
        if isGridMode {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
            collectionView.isPagingEnabled = false
            collectionView.setCollectionViewLayout(layout, animated: false)
            layoutModeButton.mode = .image(UIImage(unifyIcon: .carousel))
        } else {
            collectionView.isPagingEnabled = true
            collectionView.setCarouselLayout(animated: false)
            layoutModeButton.mode = .image(UIImage(unifyIcon: .grid))
        }
    }
}

extension CharacterListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let character = characters[indexPath.item]
        if isGridMode {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterGridCell.identifier, for: indexPath) as? CharacterGridCell {
                cell.setupData(character)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterPageCell.identifier, for: indexPath) as? CharacterPageCell {
                cell.setupData(character)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridMode {
            let width: CGFloat = collectionView.bounds.size.width
            let padding: CGFloat = 32 - 8 // LR padding - interitem spacing
            let itemWidth: CGFloat = (width / 2) - padding
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            return collectionView.bounds.size
        }
    }
}
