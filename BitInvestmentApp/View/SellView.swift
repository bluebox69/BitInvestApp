//
//  SellView.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 18.01.25.
//

import SwiftUI

struct SellView: View {
    @StateObject private var viewModel = SellViewModel()
    @State private var isRefreshing = false
    @State private var savedCoin: CoinEntity?
    
    @State private var coinAmount: String = ""
    @State private var scale: Double = 1.0
    @State private var rotation: Double = 0.0
    @State private var isBlinking = false
    @State private var showWiggle = false
    
    
    var body: some View {
        let totalCoinAmount = viewModel.portfolio?.totalCoinAmount ?? 0.0
        
        ScrollView {
            let portfolio = viewModel.portfolio
            if (portfolio != nil) {
                VStack(spacing: 20) {
                    
                    // Total Amount Section
                    VStack {
                        Text(NSLocalizedString("coinAmount", comment: "Coin Amount"))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 30)

                        
                        Text("\(totalCoinAmount, specifier: "%.6f")BTC")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(isBlinking ? .red : .black) // Blink-Farbe
                            .onAppear {
                                if totalCoinAmount == 0.0 {
                                    startBlinking()
                                }
                            }
                            .onChange(of: totalCoinAmount) { newValue in
                                if newValue == 0.0 {
                                    startBlinking()
                                } else {
                                    isBlinking = false
                                }
                            }
                        
                        
                        HStack {
                            if ((viewModel.coin?.price) != nil) {
                                Text("1 BTC = $\(viewModel.coin!.price, specifier: "%.2f")")
                                    .font(.title2)
                                    .scaleEffect(isRefreshing ? 1.14 : 1.0)
                                    .animation(.easeInOut(duration: 1.0), value: isRefreshing)
                                
                            } else {
                                Text(NSLocalizedString("loadingCoinValue", comment: "Loading Coin Error"))
                                    .font(.caption)
                            }
                            Spacer()
                            
                            Button(action: {
                                isRefreshing = true
                                withAnimation(.linear(duration: 1)) {
                                    rotation += 360
                                }
                                viewModel.refreshPortfolio {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        isRefreshing = false
                                    }
                                }
                            }) {
                                Image("ArrowRefresh")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(x: -1, y: 1)
                                    .frame(width: 30, height: 30)
                                    .rotationEffect(.degrees(rotation))
                                    .animation(.linear(duration: 1), value: rotation)
                            }
                            
                            Spacer()
                        }
                        HStack {
                            Text(String.localizedStringWithFormat(
                                NSLocalizedString("lastUpdate", comment: "Label for last update"),
                                viewModel.portfolio?.lastUpdated?.formatted() ?? NSLocalizedString("unknown", comment: "Unknown date placeholder")
                                ))
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .scaleEffect(isRefreshing ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 1.0), value: isRefreshing)
                            Spacer()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(NSLocalizedString("coinAmount", comment: "Amount in Coin"))
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Button(
                                NSLocalizedString("sellAllCoins", comment: "invest all Coins"),
                                action: {
                                    coinAmount = String(totalCoinAmount)
                                }
                            )
                            .foregroundColor(.gray)
                            .shadow(color: Color.black.opacity(0.1), radius: 1.5, x: 0, y: 0.5)
                        }
                       
                        TextField(
                            NSLocalizedString("enterCoinAmount", comment: "Enter Amount in Coin"),
                            text: $coinAmount
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
                            viewModel.addInvestment(investmentAmountInCoins: Double(coinAmount) ?? 0.0, purchaseType: PurchaseType.sell)
                        }
                        
                        //Berechnung der Coins in Dollar
                        if let amount = Double(coinAmount), amount > 0 {
                            Text(String.localizedStringWithFormat(
                                NSLocalizedString("receiveDollar", comment: "Message showing the estimated amount of Dollar the user will receive"),
                                viewModel.calculateBitcoinAmountInDollar(coinAmount: amount))
                                 )
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    let buttonColor: Color = (Double(coinAmount) ?? 0) > 0 ? .lightYellow : .lightRed
                    CustomButton(
                        title: NSLocalizedString("confirm", comment: "Confirm"),
                        backgroundColor: buttonColor,
                        action: {
                            if let amount = Double(coinAmount), amount > 0, amount <= totalCoinAmount {
                                viewModel.addInvestment(
                                    investmentAmountInCoins: amount,
                                    purchaseType: PurchaseType.sell
                                )
                                coinAmount = ""
                            } else {
                                withAnimation(.default) {
                                    showWiggle = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    coinAmount = ""
                                    showWiggle = false
                                }
                            }
                        },
                        iconName: "CheckBroken"
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .modifier(WiggleEffect(shouldWiggle: showWiggle))
                }
                .padding()
            } else {
                VStack {
                    ProgressView()
                    Text(NSLocalizedString("loadingPortfolio", comment: "Loading Portfolio"))
                        .font(.caption)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadPortfolio()
            viewModel.loadCoin { _ in}
            savedCoin = viewModel.fetchSavedCoin()
            viewModel.refreshPortfolio {
            }
        }
    }
    
    func startBlinking() {
        isBlinking = true
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.5)) {
                isBlinking.toggle()
            }
            if viewModel.portfolio?.totalCoinAmount != 0.0 {
                timer.invalidate()
            }
        }
    }
    
}
