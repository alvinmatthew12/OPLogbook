//
//  CharacterUseCase.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import RxSwift

internal final class CharacterUseCase {
    internal var getCharacters: () -> Observable<Result<[Character], NetworkError>>
    internal var getCharacter: (_ id: String) -> Observable<Result<Character, NetworkError>>
    
    internal init(
        getCharacters: @escaping () -> Observable<Result<[Character], NetworkError>>,
        getCharacter: @escaping (_ id: String) -> Observable<Result<Character, NetworkError>>
    ) {
        self.getCharacters = getCharacters
        self.getCharacter = getCharacter
    }
}

extension CharacterUseCase {
    internal static var live: Self {
        let decoder = JSONDecoder()
        return Self(
            getCharacters: {
                decoder.readJson(fileName: "Characters", keyPath: "data")
            },
            getCharacter: { id in
                return decoder.readJson([Character].self, fileName: "Characters", keyPath: "data")
                    .map { result -> Result<Character, NetworkError> in
                        switch result {
                        case let .success(data):
                            if let character = data.first(where: { $0.id == id }) {
                                return .success(character)
                            } else {
                                return .failure(.serverError)
                            }
                            
                        case let .failure(error):
                            return .failure(error)
                        }
                    }
            }
        )
    }
}
