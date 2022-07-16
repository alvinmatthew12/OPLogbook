//
//  JSONDecoder+Extension.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import RxSwift

extension JSONDecoder {
    public func readJson<T: Decodable>(fileName: String, keyPath: String? = nil, bundle: Bundle = Bundle.main) -> Observable<Result<T, NetworkError>> {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else { return .just(.failure(.serverError)) }
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            
            if let keyPath = keyPath {
                let toplevel = try JSONSerialization.jsonObject(with: data)
                if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
                    let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
                    let jsonData = try decoder.decode(T.self, from: nestedJsonData)
                    return .just(.success(jsonData))
                } else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
                }
            } else {
                let jsonData = try decoder.decode(T.self, from: data)
                return .just(.success(jsonData))
            }
        } catch {
            return .just(.failure(.decodeError))
        }
    }
}
