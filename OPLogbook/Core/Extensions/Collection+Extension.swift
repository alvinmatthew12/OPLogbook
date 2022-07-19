//
//  Collection+Extension.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 18/07/22.
//

import Foundation

extension Collection {
    public subscript(safe index: Index) -> Element? {
        return (index >= startIndex && index < endIndex) ? self[index] : nil
    }
    
    public var isNotEmpty: Bool {
        self.isEmpty == false
    }
}
