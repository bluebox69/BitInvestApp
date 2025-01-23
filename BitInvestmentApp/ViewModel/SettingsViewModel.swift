//
//  SettingsViewModel.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 21.01.25.
//

import Foundation
class SettingsViewModel: ObservableObject {
    @Published var portfolio: PortfolioEntity?
    @Published var investments: [InvestmentEntity] = []

    
    private let persistenceController = PersistenceController.shared
    

    
    //Portfolio
    func loadPortfolio() {
        self.portfolio = persistenceController.fetchPortfolio()
        if portfolio == nil {
            print("No Portfolio found!")
        } else {
            print("Portfolio loaded")
        }
    }
    
    func addMoney(moneyAmount: Double) {
        persistenceController.addMoney(id: "portfolio", moneyAmount: moneyAmount)
    }
    
    func resetPortfolio() {
        updatePortfolio(
            totalCash: 20000.0,
            totalInvestment: 0.0,
            coinName: "Bitcoin",
            coinSymbol: "BTC",
            totalCoinAmount: 0.0
        )
        deleteAllInvestments()
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
    
    func deleteAllInvestments() {
        persistenceController.deleteAllInvestments()
        //loadInvestments() // Aktualisiere die Liste
    }
    
}
