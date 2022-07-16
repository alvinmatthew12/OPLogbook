//
//  CharacterUseCase.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import RxSwift

internal final class CharacterUseCase {
    internal var getCharacters: () -> Observable<Result<[Character], NetworkError>>
    
    internal init(
        getCharacters: @escaping () -> Observable<Result<[Character], NetworkError>>
    ) {
        self.getCharacters = getCharacters
    }
}

extension CharacterUseCase {
    internal static var live: Self {
        let decoder = JSONDecoder()
        return Self(
            getCharacters: {
                decoder.readJson(fileName: "Characters", keyPath: "data")
            }
        )
    }
}
