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
    @IBOutlet weak var listViewContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusBarView: UIView!
    @IBOutlet private weak var navigationBarView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    
    internal var imageView = OPImageView()
    
    private let registerCells: ListView<CharacterDetailComponent>.RegisterCells = { 
        [
            .init(CharacterDetailImageCell.self, forCellWithReuseIdentifier: CharacterDetailImageCell.identifier),
            .init(nib: CharacterDetailNameCell.nib, forCellWithReuseIdentifier: CharacterDetailNameCell.identifier),
            .init(CharacterDetailDescriptionCell.self, forCellWithReuseIdentifier: CharacterDetailDescriptionCell.identifier),
            .init(nib: CharacterDetailVStackTileCell.nib, forCellWithReuseIdentifier: CharacterDetailVStackTileCell.identifier),
            .init(CharacterDetailLabelCell.self, forCellWithReuseIdentifier: CharacterDetailLabelCell.identifier),
            .init(nib: CharacterDetailAttributeTileCell.nib, forCellWithReuseIdentifier: CharacterDetailAttributeTileCell.identifier),
            .init(CharacterDetailAttributeSliderCell.self, forCellWithReuseIdentifier: CharacterDetailAttributeSliderCell.identifier)
        ]
    }
    
    private let customizableLayout: ListView<CharacterDetailComponent>.CustomizableLayout = { item in
        let defaultMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        switch item {
        case .image:
            return .fullWidth(lineSpacing: 20)
            
        case .name, .description:
            return .fullWidth(
                margins: defaultMargins,
                lineSpacing: 30
            )
            
        case .vStackTile:
            return .staggered(
                margins: defaultMargins,
                interItemSpacing: 10,
                lineSpacing: 15
            )
            
        case .label:
            return .fullWidth(
                margins: defaultMargins,
                lineSpacing: 0
            )
            
        case .attributeTile:
            return .fullWidth(
                margins: defaultMargins,
                lineSpacing: 15
            )
            
        case .attributeSlider:
            return .fullWidth(
                margins: .zero,
                lineSpacing: 15
            )
        }
    }
    
    private lazy var listView: ListView<CharacterDetailComponent> = .init(registerCells: registerCells, customizableLayout: customizableLayout) { [weak self] collectionView, indexPath, item in
            switch item {
            case let .image(url):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailImageCell.identifier, for: indexPath) as? CharacterDetailImageCell {
                    cell.imageView.url = url
                    return cell
                }
                
            case let .name(epithet, name, affiliationImageName):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailNameCell.identifier, for: indexPath) as? CharacterDetailNameCell {
                    cell.setupData(epithet, name, affiliationImageName)
                    return cell
                }
                
            case let .description(text):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailDescriptionCell.identifier, for: indexPath) as? CharacterDetailDescriptionCell {
                    cell.label.attributedText = .paragraph2(text, alignment: .justified)
                    return cell
                }
                
            case let .vStackTile(label, value):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailVStackTileCell.identifier, for: indexPath) as? CharacterDetailVStackTileCell {
                    cell.setup(label: label, value: value)
                    return cell
                }
                
            case let .label(attributedString):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailLabelCell.identifier, for: indexPath) as? CharacterDetailLabelCell {
                    cell.label.attributedText = attributedString
                    return cell
                }
                
            case let .attributeTile(data):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailAttributeTileCell.identifier, for: indexPath) as? CharacterDetailAttributeTileCell {
                    cell.setupData(data)
                    return cell
                }
                
            case let .attributeSlider(items):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailAttributeSliderCell.identifier, for: indexPath) as? CharacterDetailAttributeSliderCell {
                    cell.items = items
                    return cell
                }
            }
            return nil
        }
    
    
    private let disposeBag = DisposeBag()
    private let viewModel: CharacterDetailViewModel
    
    internal init(id: String) {
        viewModel = CharacterDetailViewModel(id: id, useCase: .live)
        super.init(nibName: "CharacterDetailViewController", bundle: nil)
    }
    
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        listView.backgroundColor = .BB30
        DispatchQueue.main.async {
            let screenSize = UIScreen.main.bounds.size
            self.view.frame.size = screenSize
            self.listViewContainer.frame.size.width = screenSize.width
            self.listView.fixInView(self.listViewContainer)
        }
        setupImageView()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            self.bindViewModel()
            self.setupRedux()
        }
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
        imageView.topAnchor.constraint(equalTo: self.listViewContainer.topAnchor, constant: topConstraint).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    private func bindViewModel() {
        let input = CharacterDetailViewModel.Input(
            didLoadTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.components
            .drive(onNext: { [weak self] components in
                self?.listView.performUpdates(components)
            })
            .disposed(by: disposeBag)
        
        output.gridImageUrl
            .drive(onNext: { [weak self] url in
                self?.imageView.url = url
            })
            .disposed(by: disposeBag)
        
        output.title
            .drive(onNext: { [weak self] title in
                self?.titleLabel.attributedText = .display1(title, alignment: .center, textStyle: [.bold])
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
        
        listView.didScroll = { [weak self] scrollView in
            self?.handleNavigationBarAnimcation(yOffset: scrollView.contentOffset.y)
        }
    }
    
    private func handleNavigationBarAnimcation(yOffset: CGFloat) {
        if yOffset > 150 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                guard let self = self else { return }
                self.statusBarView.backgroundColor = .BB50
                self.navigationBarView.backgroundColor = .BB50
                self.titleLabel.alpha = 1
            })
            
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                self.statusBarView.backgroundColor = .clear
                self.navigationBarView.backgroundColor = .clear
                self.titleLabel.alpha = 0
            })
        }
    }
}
