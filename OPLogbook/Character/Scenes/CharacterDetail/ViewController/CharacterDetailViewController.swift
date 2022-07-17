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
    @IBOutlet private weak var collectionView: UICollectionView!
    
    internal var imageView = OPImageView()
    
    private let disposeBag = DisposeBag()
    private let viewModel: CharacterDetailViewModel
    internal var components: [CharacterDetailComponent] = []
    
    internal init(id: String) {
        viewModel = CharacterDetailViewModel(id: id, useCase: .live)
        super.init(nibName: "CharacterDetailViewController", bundle: nil)
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupCollectionView()
        bindViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupImageView() {
        let width: CGFloat = collectionView.bounds.size.width
        let padding: CGFloat = 30 + 12.5 + 10 // LR padding + interitem spacing
        let itemWidth: CGFloat = (width / 2) - padding
        
        let itemCenter = (itemWidth / 2)
        let topConstraint = 123 - itemCenter
        print(topConstraint)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.zPosition = -1
        imageView.imageShape = .rect(cornerRadius: 15)
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: itemWidth).isActive = true
        imageView.topAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: topConstraint).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor).isActive = true
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
        layout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: 50)
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView.register(CharacterDetailImageCell.self, forCellWithReuseIdentifier: CharacterDetailImageCell.identifier)
    }
    
    private func bindViewModel() {
        let input = CharacterDetailViewModel.Input(
            didLoadTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.components
            .drive(onNext: { [weak self] components in
                self?.components = components
                self?.collectionView.reloadData()
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
}
