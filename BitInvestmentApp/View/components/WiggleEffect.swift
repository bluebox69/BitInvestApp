//
//  WiggleEffect.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 18.01.25.
//

import SwiftUI

struct WiggleEffect: ViewModifier {
    var shouldWiggle: Bool

    func body(content: Content) -> some View {
        content
            .offset(x: shouldWiggle ? 10 : 0)
            .animation(
                shouldWiggle ?
                Animation.easeInOut(duration: 0.2).repeatCount(3, autoreverses: true) :
                .default,
                value: shouldWiggle
            )
    }
}
