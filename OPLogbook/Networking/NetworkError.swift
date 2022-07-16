//
//  NetworkError.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case serverError
    case decodeError
}
