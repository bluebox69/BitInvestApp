//
//  rounded.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 20.01.25.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
