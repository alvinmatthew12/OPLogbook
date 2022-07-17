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
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let backButton = OPButton(
        title: "",
        mode: .image(UIImage(unifyIcon: .chevronLeft)),
        size: .micro
    )
    
    internal var imageView = OPImageView()
    
    private let disposeBag = DisposeBag()
    private let viewModel: CharacterDetailViewModel
    internal var components: [CharacterDetailComponent] = []
    
    internal init(id: String) {
        viewModel = CharacterDetailViewModel(id: id, useCase: .live)
        super.init(nibName: nil, bundle: nil)
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = false
        backButton.isUserInteractionEnabled = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 300)
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.fixInView(view, attributes: [.top, .leading, .trailing])
        
        setupBackButton()
        setupNavigationBar()
        setupCollectionView()
        bindViewModel()
        setupRedux()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        backButton.layer.zPosition = 1
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.fixInView(self.view)
        collectionView.contentInsetAdjustmentBehavior = .never
        
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
