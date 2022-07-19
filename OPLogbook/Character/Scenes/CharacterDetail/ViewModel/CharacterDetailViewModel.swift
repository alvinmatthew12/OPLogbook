//
//  CharacterDetailViewModel.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import RxCocoa
import RxSwift

internal final class CharacterDetailViewModel: ViewModelType {
    
    private let id: String
    private let useCase: CharacterUseCase
    
    internal init(id: String, useCase: CharacterUseCase) {
        self.id = id
        self.useCase = useCase
    }
    
    internal struct Input {
        internal let didLoadTrigger: Driver<Void>
    }
    
    internal struct Output {
        internal let components: Driver<[CharacterDetailComponent]>
        internal let gridImageUrl: Driver<URL?>
        internal let title: Driver<String>
        internal let networkError: Driver<NetworkError>
    }
    
    internal func transform(input: Input) -> Output {
        
        let response = input.didLoadTrigger
            .flatMapLatest { [id, useCase] _ in
                useCase.getCharacter(id)
                    .asDriver(onErrorDriveWith: .never())
            }
        
        let character = response
            .compactMap { result -> Character? in
                guard case let .success(data) = result else { return nil }
                return data
            }
        
        let components = character
            .flatMapLatest { char -> Driver<[CharacterDetailComponent]> in
                var components: [CharacterDetailComponent] = [
                    .image(char.images.bannerURL),
                    .name(char.epithet, char.name, char.affiliation.imageName),
                    .description(char.description),
                    .vStackTile(label: "Affiliation", value: char.affiliation.name),
                    .vStackTile(label: "Bounty", value: char.bounty.currencyDecimalFormat),
                    .vStackTile(label: "Birthday", value: char.birthday),
                    .vStackTile(label: "Origin", value: char.origin),
                ]
                
                for attr in char.attributes {
                    components.append(.label(.heading3(attr.title)))
                    switch attr.type {
                    case .tile:
                        for item in attr.items {
                            components.append(.attributeTile(item))
                        }
                    case .slider:
                        components.append(.attributeSlider(attr.items))
                    case .none:
                        break
                    }
                }
                
                return .just(components)
            }
        
        let gridImageUrl = character
            .flatMapLatest { character -> Driver<URL?> in
                return .just(character.images.gridURL)
            }
        
        let title = character
            .flatMapLatest { character -> Driver<String> in
                return .just(character.name)
            }
            
        
        let networkError = response
            .compactMap { result -> NetworkError? in
                guard case let .failure(error) = result else { return nil }
                return error
            }
        
        return Output(
            components: components,
            gridImageUrl: gridImageUrl,
            title: title,
            networkError: networkError
        )
    }
}
