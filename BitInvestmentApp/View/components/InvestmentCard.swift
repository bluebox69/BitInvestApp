//
//  InvestmentCard.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import SwiftUI

struct InvestmentCard: View {
    var coinName: String
    var coinSymbol: String
    var totalCoinAmount: Double
    var totalInvestment: Double
    var transactionType: PurchaseType? = nil
    var transactionDate: Date? = nil
    var iconName: String
    var color: Color

    var body: some View {
        HStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(color)
                .overlay(
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                )

            VStack(alignment: .leading) {
                Text(coinName)
                    .font(.title2)
                    .foregroundColor(.lightWhite)

                if let date = transactionDate {
                    Text(date.formatted())
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text(coinSymbol)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("$\(totalInvestment, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.lightWhite)

                Text("\(totalCoinAmount) BTC")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 18).fill(Color(.darkGrey)))
        .shadow(radius: 1)
    }
}
