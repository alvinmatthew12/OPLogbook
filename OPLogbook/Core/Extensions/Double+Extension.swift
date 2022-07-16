//
//  Double+Extension.swift
//  OPLogbook
//
//  Created by Alvin Matthew Pratama on 16/07/22.
//

import Foundation

extension Double {
    public var currencyDecimalFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self))!
    }
}
