//
//  HomeView.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isRefreshing = false
    @State private var savedCoin: CoinEntity?
    @State private var scale: Double = 1.0
    @State private var rotation: Double = 0.0
    @State private var isBlinking = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    
    static let reminderNotification = Notification.Name("reminderNotification")
    var dataModel = DataModel() // ruft die Init methode auf

    var body: some View {
        let totalCash = viewModel.portfolio?.totalCash ?? 0.0
        
        ZStack {
            NavigationStack {
                ScrollView {
                    let portfolio = viewModel.portfolio
                    if (portfolio != nil) {
                        VStack(spacing: 20) {
                            HStack {
                                Text(String.localizedStringWithFormat(
                                    NSLocalizedString("lastUpdate", comment: "Label for last update"),
                                    viewModel.portfolio?.lastUpdated?.formatted() ?? NSLocalizedString("unknown", comment: "Unknown date placeholder")
                                    ))
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            
                            // Total Amount Section
                            VStack {
                                HStack {
                                    Text(NSLocalizedString("currentTPortfolioValue", comment: "Total Portfolio Amount"))
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    
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
                                        NotificationCenter.default.post(name: HomeView.reminderNotification, object: nil, userInfo: nil)
                                    }) {
                                        Image("ArrowRefresh")
                                            .resizable()
                                            .scaledToFit()
                                            .scaleEffect(x: -1, y: 1)
                                            .frame(width: 30, height: 30)
                                            .rotationEffect(.degrees(rotation))
                                            .animation(.linear(duration: 1), value: rotation)
                                    }
                                }
                                
                                Text("$\(viewModel.currentPortfolioValue, specifier: "%.2f")")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .scaleEffect(isRefreshing ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 1.0), value: isRefreshing)
                                
                                HStack {
                                    if let performance = viewModel.portfolioPerformance {
                                        Text("$\(performance.profitOrLoss, specifier: "%.2f")")
                                            .foregroundColor(performance.profitOrLoss > 0 ? .green : .red)
                                            .animation(.easeIn(duration: 1), value: isRefreshing)
                                        Text("\(performance.performancePercentage, specifier: "%.2f")%")
                                            .foregroundColor(performance.performancePercentage > 0 ? .green : .red)
                                    }
                                }
                            }
                            
                            // Portfolio Section
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(NSLocalizedString("investments", comment: "lable for investments Headline"))
                                        .font(.headline)
                                    Spacer()
                                    Text(String.localizedStringWithFormat(
                                        NSLocalizedString("totalCash", comment: "Total Amount of Money"),
                                        totalCash
                                        ))
                                        .font(.subheadline)
                                        .foregroundColor(isBlinking ? .red : .black)
                                        .onAppear {
                                            if totalCash == 0.0 {
                                                startBlinking()
                                            }
                                        }
                                        .onChange(of: totalCash) { newValue in
                                            if newValue == 0.0 {
                                                startBlinking()
                                            } else {
                                                isBlinking = false
                                            }
                                        }
                                }
                                
                                if let portfolio = viewModel.portfolio,
                                   let coin = viewModel.coin {
                                    let currentMoneyInvested = portfolio.totalCoinAmount * coin.price
                                    InvestmentCard(
                                        coinName: "Bitcoin",
                                        coinSymbol: "BTC",
                                        totalCoinAmount: viewModel.portfolio!.totalCoinAmount,
                                        totalInvestment: currentMoneyInvested,
                                        iconName: "Vector",
                                        color: .lightRed
                                    )
                                } else {
                                    Text(NSLocalizedString("portfolioOrCoinDataError", comment: "Portfolio or Coin are not available"))
                                        .foregroundColor(.red)
                                }
                                
                                HStack(spacing: 20) {
                                    NavigationLink(NSLocalizedString("buy", comment: "Buy Button"), destination: BuyView())
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(.lightYellow)
                                        .foregroundColor(.black)
                                        .cornerRadius(20)
                                        .fontWeight(.bold)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                                    
                                    NavigationLink(NSLocalizedString("sell", comment: "Sell button"), destination: SellView())
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(.lightRed)
                                        .foregroundColor(.black)
                                        .cornerRadius(20)
                                        .fontWeight(.bold)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                                }
                            }
                            
                            // Transactions Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text(NSLocalizedString("transactions", comment: "Transaction Headline"))
                                    .font(.headline)
                                
                                ForEach(viewModel.investments.reversed()) { investment in
                                    let transactionType = PurchaseType(rawValue: investment.purchaseType)
                                    let iconName = (transactionType == .buy) ? "ArrowCircleUp" : "ArrowCircleDown"
                                    let iconColor: Color = (transactionType == .buy) ? .lightYellow : .lightRed
                                    
                                    InvestmentCard(
                                        coinName: investment.coinName ?? "Bitcoin",
                                        coinSymbol: investment.coinSymbol ?? "BTC",
                                        totalCoinAmount: investment.quantity,
                                        totalInvestment: investment.investmentCost,
                                        transactionType: transactionType,
                                        transactionDate: investment.date,
                                        iconName: iconName,
                                        color: iconColor
                                    )
                                    .transition(.slide)
                                }
                            }
                        }
                        .padding()
                    } else {
                        VStack {
                            ProgressView(NSLocalizedString("loadingPortfolio", comment: "Loading Portfolio Error"))
                        }
                        .padding()
                    }
                }
            }
            
            if showToast {
                VStack {
                    Spacer()
                    ToastView(message: toastMessage)
                        .padding(.bottom, 40)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: showToast)
                }
            }
        }
        .onAppear {
            viewModel.loadPortfolio()
            viewModel.loadCoin { _ in }
            viewModel.loadInvestments()
            NotificationManager.shared.schedulePortfolioReminder()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PortfolioRefreshed"))) { notification in
            if let coinPrice = notification.userInfo?["coinPrice"] as? String {
                toastMessage = String.localizedStringWithFormat(
                    NSLocalizedString("currentCoinValue", comment: "Aktueller Preis"),
                    coinPrice
                    )
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showToast = false
                }
            }
        }


        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LowCashWarning"))) { _ in
            alertMessage = NSLocalizedString("moneyWarning", comment: "Out of Money")
            showAlert = true
            isBlinking = true
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(NSLocalizedString("warning", comment: "Warning")),
                message: Text(alertMessage),
                dismissButton: .default(Text(NSLocalizedString("ok", comment: "OK")))
            )
        }
    }
    
    func startBlinking() {
        isBlinking = true
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.5)) {
                isBlinking.toggle()
            }
            if viewModel.portfolio?.totalCash != 0.0 {
                timer.invalidate()
            }
        }
    }
}
