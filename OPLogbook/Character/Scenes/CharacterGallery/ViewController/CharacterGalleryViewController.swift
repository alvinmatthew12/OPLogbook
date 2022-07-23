//
//  CharacterGalleryViewController.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 23/07/22.
//

import RxCocoa
import RxSwift
import UIKit

internal final class CharacterGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CarouselLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        collectionView.register(CharacterGalleryCell.self, forCellWithReuseIdentifier: CharacterGalleryCell.identifier)
        return collectionView
    }()
    
    private let closeButton: OPButton = {
        let button = OPButton(title: "")
        button.mode = .image(UIImage(unifyIcon: .closeCircleFill, color: .BW50))
        button.size = .micro
        return button
    }()
    
    private var gallery: [CharacterGalleryData] = []
    
    private let disposeBag = DisposeBag()
    private let viewModel: CharacterGalleryViewModel
    
    internal init(id: String) {
        viewModel = CharacterGalleryViewModel(id: id, useCase: .live)
        super.init(nibName: nil, bundle: nil)
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .BB30
        
        collectionView.fixInView(self.view)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + 20).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        closeButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = CharacterGalleryViewModel.Input(
            didLoadTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.gallery
            .drive(onNext: { [weak self] gallery in
                self?.gallery = gallery
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.networkError
            .drive(onNext: { [weak self] error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = gallery[indexPath.item]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterGalleryCell.identifier, for: indexPath) as? CharacterGalleryCell {
            cell.setupData(data)
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
    }
}
