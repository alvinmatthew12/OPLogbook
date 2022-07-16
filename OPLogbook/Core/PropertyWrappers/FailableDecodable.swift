//
//  FailableDecodable.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 17/07/22.
//

import Foundation

@propertyWrapper
public struct FailableDecodable<Value> {
    public var wrappedValue: Value?
    
    public init(wrappedValue: Value?) {
        self.wrappedValue = wrappedValue
    }
}

extension FailableDecodable: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        wrappedValue = try? container?.decode(Value.self)
    }
}

extension FailableDecodable: Equatable where Value: Equatable { }

/**
 This will overload synthesized implementation for type 'FailableDecodable<T>'
 and will handle no coding key like optional type
 */
extension KeyedDecodingContainer {
    public func decode<T>(
        _ type: FailableDecodable<T>.Type,
        forKey key: Self.Key
    ) throws -> FailableDecodable<T> where T: Decodable {
        return try decodeIfPresent(type, forKey: key) ?? FailableDecodable<T>(wrappedValue: nil)
    }
}
