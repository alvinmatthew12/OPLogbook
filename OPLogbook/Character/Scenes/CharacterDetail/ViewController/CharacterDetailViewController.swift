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
    @IBOutlet private weak var listViewContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusBarView: UIView!
    @IBOutlet private weak var navigationBarView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var colorView: UIView!
    @IBOutlet private weak var colorViewHeightConstraint: NSLayoutConstraint!
    
    private let registerCells: [ListViewReuseableCell] = [
        CharacterDetailImageCell.reusableCell,
        CharacterDetailNameCell.reusableCell,
        CharacterDetailDescriptionCell.reusableCell,
        CharacterDetailVStackTileCell.reusableCell,
        CharacterDetailLabelCell.reusableCell,
        CharacterDetailAttributeTileCell.reusableCell,
        CharacterDetailAttributeSliderCell.reusableCell
    ]
    
    private lazy var listView: ListView<CharacterDetailComponent> = .init(
        registerCells: registerCells,
        customizableLayout: { $0.customizableLayout }
    ) { [weak self] collectionView, indexPath, item in
        guard let self = self else { return nil }
        
        switch item {
        case let .image(url, color):
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterDetailImageCell.identifier, for: indexPath) as? CharacterDetailImageCell {
                cell.setup(url: url, backgroundColor: color)
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
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override internal func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.isHidden = true
        listView.backgroundColor = .clear
        listView.fixInView(listViewContainer)
        bindViewModel()
        setupRedux()
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
        
        output.title
            .drive(onNext: { [weak self] title in
                self?.titleLabel.attributedText = .display1(title, alignment: .center, textStyle: [.bold])
            })
            .disposed(by: disposeBag)
        
        output.backgroundColor
            .drive(onNext: { [weak self] color in
                self?.colorView.backgroundColor = color
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
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        listView.didScroll = { [weak self] scrollView in
            self?.handleYOffsetDidChange(scrollView.contentOffset.y)
        }
    }
    
    private func handleYOffsetDidChange(_ yOffset: CGFloat) {
        colorView.isHidden = yOffset > 5
        colorViewHeightConstraint.constant = yOffset < -235 ? 500 : 240
        
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
