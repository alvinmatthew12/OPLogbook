//
//  ViewModelType.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import Foundation

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
