//
//  CharacterListViewModel.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import RxCocoa
import RxSwift

internal final class CharacterListViewModel: ViewModelType {
    
    private let useCase: CharacterUseCase
    
    internal init(useCase: CharacterUseCase) {
        self.useCase = useCase
    }
    
    internal struct Input {
        internal let didLoadTrigger: Driver<Void>
    }
    
    internal struct Output {
        internal let characters: Driver<[Character]>
        internal let networkError: Driver<NetworkError>
    }
    
    internal func transform(input: Input) -> Output {
        
        let response = input.didLoadTrigger
            .flatMapLatest { [useCase] _ in
                useCase.getCharacters()
                    .asDriver(onErrorDriveWith: .never())
            }
        
        let characters = response
            .compactMap { result -> [Character]? in
                guard case let .success(data) = result else { return nil }
                return data
            }
        
        let networkError = response
            .compactMap { result -> NetworkError? in
                guard case let .failure(error) = result else { return nil }
                return error
            }
        
        return Output(
            characters: characters,
            networkError: networkError
        )
    }
}
