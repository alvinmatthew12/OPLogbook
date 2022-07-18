//
//  CharacterDetailViewController.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import RxCocoa
import RxSwift
import UIKit

internal final class CharacterDetailViewController: UIViewController {
    internal struct CollectionData {
        internal let components: [CharacterDetailComponent]
        internal let margins: UIEdgeInsets
    }
    
    @IBOutlet internal weak var collectionView: UICollectionView!
    @IBOutlet private weak var backButton: UIButton!
    
    internal var imageView = OPImageView()
    
    private let disposeBag = DisposeBag()
    private let viewModel: CharacterDetailViewModel
    internal var collectionData: [CollectionData] = []
    
    internal init(id: String) {
        viewModel = CharacterDetailViewModel(id: id, useCase: .live)
        super.init(nibName: "CharacterDetailViewController", bundle: nil)
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let screenSize = UIScreen.main.bounds.size
            self.view.frame.size = screenSize
        }
        
        setupImageView()
        setupCollectionView()
        bindViewModel()
        setupRedux()
    }
    
    private func setupImageView() {
        let width: CGFloat = view.bounds.size.width
        let padding: CGFloat = 30 + 25 + 10 // LR padding + interitem spacing
        let itemWidth: CGFloat = (width / 2) - padding
        
        let itemCenter = (itemWidth / 2)
        let topConstraint = 123 - itemCenter
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.zPosition = -1
        imageView.imageShape = .rect(cornerRadius: 15)
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: itemWidth).isActive = true
        imageView.topAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: topConstraint).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .BB30
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 32, right: 0)
        registerCell(collectionView)
    }
    
    private func bindViewModel() {
        let input = CharacterDetailViewModel.Input(
            didLoadTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.components
            .drive(onNext: { [weak self] components in
                self?.performUpdates(components)
            })
            .disposed(by: disposeBag)
        
        output.gridImageUrl
            .drive(onNext: { [weak self] url in
                self?.imageView.url = url
            })
            .disposed(by: disposeBag)
        
        output.networkError
            .drive(onNext: { [weak self] error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupRedux() {
        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
