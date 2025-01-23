//
//  CoinViewModel.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var coin: Coin? {
        didSet {
            updatePortfolioPerformance()
        }
    }
    @Published var portfolio: PortfolioEntity? {
        didSet {
            updatePortfolioPerformance()
        }
    }
    @Published var investments: [InvestmentEntity] = [] {
        didSet {
            updatePortfolioPerformance()
        }
    }
    @Published var portfolioPerformance: (profitOrLoss: Double, performancePercentage: Double)?
    @Published var currentPortfolioValue: Double = 0.0

    private let apiService = APIService()
    private let persistenceController = PersistenceController.shared
    
    // Lade Bitcoin-Daten
    func loadCoin(completion: @escaping (Coin?) -> Void) {
        apiService.fetchCoin { [weak self] fetchedCoin in
            DispatchQueue.main.async {
                if let coin = fetchedCoin {
                    self?.coin = coin
                    self?.saveCoinToCoreData(coin)
                    print("Aktueller Kurs: \(coin.price)")
                    completion(coin)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    private func saveCoinToCoreData(_ coin: Coin) {
        persistenceController.saveCoin(coin)
    }
    
    private func checkCashLevel() {
        if portfolio?.totalCash == 0 {
            NotificationCenter.default.post(name: Notification.Name("LowCashWarning"), object: nil)
        }
    }

    // Lade Portfolio
    func loadPortfolio() {
        self.portfolio = persistenceController.fetchPortfolio()
        if portfolio == nil {
            initializeDefaultPortfolio()
            print("No Portfolio found!")
        } else {
            print("Portfolio loaded")
        }
        checkCashLevel()
    }
    
    private func initializeDefaultPortfolio() {
        let defaultCash: Double = 20000.0
        let defaultInvestment: Double = 0.0
        let defaultCoinName: String = "Bitcoin"
        let defaultCoinSymbol: String = "BTC"
        let defaultCoinAmount: Double = 0.0

        persistenceController.savePortfolio(
            totalCash: defaultCash,
            totalInvestment: defaultInvestment,
            lastUpdated: Date(),
            coinName: defaultCoinName,
            coinSymbol: defaultCoinSymbol,
            totalCoinAmount: defaultCoinAmount
        )
        loadPortfolio()
    }

    // Aktualisiere Portfolio-Performance und aktuellen Wert
    private func updatePortfolioPerformance() {
        guard let portfolio = portfolio, let coin = coin else {
            self.currentPortfolioValue = 0.0
            self.portfolioPerformance = (profitOrLoss: 0.0, performancePercentage: 0.0)
            return
        }
        
        var totalCoins: Double = 0.0
        var weightedInvestmentCost: Double = 0.0
        
        for investment in investments {
            if investment.purchaseType == "Buy" {
                totalCoins += investment.quantity
                weightedInvestmentCost += investment.quantity * investment.purchasePrice
                weightedInvestmentCost = weightedInvestmentCost.rounded(toPlaces: 2)
            } else if investment.purchaseType == "Sell" {
                let adjustedQuantity = min(investment.quantity, totalCoins)
                if totalCoins > 0 { // verhindert eine Division durch 0
                    weightedInvestmentCost -= adjustedQuantity * (weightedInvestmentCost / totalCoins)
                }
                totalCoins -= adjustedQuantity
            }
        }

        // berechnung aller Coins mit aktuellem CoinWert
        let currentInvestmentValue = totalCoins * coin.price
        
        // Gesamtportfolio-Wert
        let portfolioValue = currentInvestmentValue + portfolio.totalCash
        
        // Profit/Loss basierend auf ursprünglichem Kaufwert
        var profitOrLoss: Double
        if totalCoins > 0 {
            profitOrLoss = portfolioValue - weightedInvestmentCost - portfolio.totalCash
        } else {
            profitOrLoss = 0.0
        }
        profitOrLoss = profitOrLoss.rounded(toPlaces: 2)
        
        // Performance-Prozentwert
        let performancePercentage: Double
        
        if weightedInvestmentCost > 0 {
            performancePercentage = (profitOrLoss / weightedInvestmentCost) * 100
        } else {
            performancePercentage = 0.0
        }

        self.currentPortfolioValue = portfolioValue
        self.portfolioPerformance = (
            profitOrLoss: profitOrLoss.isNaN ? 0.0 : profitOrLoss,
            performancePercentage: performancePercentage.isNaN ? 0.0 : performancePercentage
        )
    }

    func refreshPortfolio(completion: @escaping () -> Void) {
        loadCoin { [weak self] coin in
            if let coin = coin {
                print("Coin refreshed: \(coin.name)")
                let coinPriceFormatted = String(format: "%.2f", coin.price)
                NotificationCenter.default.post(name: Notification.Name("PortfolioRefreshed"), object: nil, userInfo: ["coinPrice": coinPriceFormatted])
            } else {
                print("Failed to refresh coin.")
            }
            DispatchQueue.main.async {
                guard let self = self, let currentPortfolio = self.portfolio else { return }
                
                let updatedPortfolio = currentPortfolio
                updatedPortfolio.lastUpdated = Date()
                self.portfolio = updatedPortfolio
            }
            completion()
        }
    }



    func updatePortfolio(
        totalCash: Double,
        totalInvestment: Double,
        coinName: String,
        coinSymbol: String,
        totalCoinAmount: Double
    ) {
        persistenceController.savePortfolio(
            totalCash: totalCash,
            totalInvestment: totalInvestment,
            lastUpdated: Date(),
            coinName: coinName,
            coinSymbol: coinSymbol,
            totalCoinAmount: totalCoinAmount
        )
        loadPortfolio()
    }

    func loadInvestments() {
        self.investments = persistenceController.fetchInvestments()
    }

    func resetPortfolio() {
        updatePortfolio(
            totalCash: 20000.0,
            totalInvestment: 0.0,
            coinName: "Bitcoin",
            coinSymbol: "BTC",
            totalCoinAmount: 0.0
        )
    }

}


