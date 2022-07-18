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
                let components: [CharacterDetailComponent] = [
                    .image(char.images.bannerURL),
                    .name(char.epithet, char.name, char.affiliation.imageName),
                    .description(char.description),
                    .vStackTile(label: "Affiliation", value: char.affiliation.name),
                    .vStackTile(label: "Bounty", value: char.bounty.currencyDecimalFormat),
                    .vStackTile(label: "Birthday", value: char.birthday),
                    .vStackTile(label: "Origin", value: char.origin)
                ]
                return .just(components)
            }
        
        let gridImageUrl = character
            .flatMapLatest { character -> Driver<URL?> in
                return .just(character.images.gridURL)
            }
            
        
        let networkError = response
            .compactMap { result -> NetworkError? in
                guard case let .failure(error) = result else { return nil }
                return error
            }
        
        return Output(
            components: components,
            gridImageUrl: gridImageUrl,
            networkError: networkError
        )
    }
}
