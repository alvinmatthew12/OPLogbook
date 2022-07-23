//
//  CharacterGalleryViewModel.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 23/07/22.
//

import RxCocoa
import RxSwift

internal final class CharacterGalleryViewModel: ViewModelType {
    
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
        internal let gallery: Driver<[CharacterGalleryData]>
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
        
        let gallery = character
            .flatMapLatest { char -> Driver<[CharacterGalleryData]> in
                return .just([.init(imageURL: char.imageURL, backgroundURL: char.backgroundURL)])
            }
        
        let networkError = response
            .compactMap { result -> NetworkError? in
                guard case let .failure(error) = result else { return nil }
                return error
            }
        
        return Output(
            gallery: gallery,
            networkError: networkError
        )
    }
}
