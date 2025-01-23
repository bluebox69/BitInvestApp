//
//  SettingsView.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 18.01.25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var moneyAmount: String = ""
    @State private var showWiggle = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(NSLocalizedString("addMoney", comment: "Add Money"))
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            TextField(
                NSLocalizedString("amountInDollar", comment: "Amount in Dollar"),
                text: $moneyAmount
            )
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.secondary, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
            .keyboardType(.decimalPad)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .onSubmit {
                if let amount = Double(moneyAmount), amount > 0{
                    viewModel.addMoney(moneyAmount: amount)
                }
            }
                
                let buttonColor: Color = (Double(moneyAmount) ?? 0) > 0 ? .lightYellow : .lightRed
                CustomButton(
                    title: NSLocalizedString("deposit", comment: "deposit"),
                    backgroundColor: buttonColor,
                    action: {
                        if let amount = Double(moneyAmount), amount > 0 {
                            viewModel.addMoney(moneyAmount: amount)
                            moneyAmount = ""
                        } else {
                            withAnimation(.default) {
                                showWiggle = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                moneyAmount = ""
                                showWiggle = false
                            }
                        }
                    },
                    iconName: "WalletAdd"
                )
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .modifier(WiggleEffect(shouldWiggle: showWiggle))
            
                HStack{
                    Text(NSLocalizedString("resetPortfolioInfo", comment: "Reset Portfolio"))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                }

                CustomButton(
                    title: NSLocalizedString("resetPortfolio", comment: "Reset Portfolio"),
                    backgroundColor: .lightRed,
                    action: {
                        viewModel.resetPortfolio()
                    },
                    iconName: "ArrowsVertical"
                )
                Spacer()
            }
        .padding()
    }
}
