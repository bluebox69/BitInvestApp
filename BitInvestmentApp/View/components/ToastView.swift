//
//  ToastView.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 21.01.25.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.headline)
            .padding()
            .background(Color.lightWhite.opacity(0.9))
            .foregroundColor(.black)
            .cornerRadius(16)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity)
    }
}
