//
//  BuyViewModel.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import Foundation

class BuyViewModel: ObservableObject {
    @Published var coin: Coin?
    @Published var portfolio: PortfolioEntity?
    @Published var investments: [InvestmentEntity] = []
    
    
    private let apiService = APIService()
    private let persistenceController = PersistenceController.shared
    
    func loadCoin(completion: @escaping (Coin?) -> Void) {
        apiService.fetchCoin { [weak self] fetchedCoin in
            DispatchQueue.main.async {
                if let coin = fetchedCoin {
                    self?.coin = coin
                    self?.persistenceController.saveCoin(coin)
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
    
    func fetchSavedCoin() -> CoinEntity? {
        return persistenceController.fetchCoin()
    }
    
    //Portfolio
    func loadPortfolio() {
        self.portfolio = persistenceController.fetchPortfolio()
        if portfolio == nil {
            print("No Portfolio found!")
        } else {
            print("Portfolio loaded")
        }
    }
    
    func refreshPortfolio(completion: @escaping () -> Void) {
        loadCoin { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self, let currentCoin = self.coin, let portfolio = self.portfolio else {
                    print("Failed to refresh portfolio.")
                    completion()
                    return
                }

                // Portfolio-Daten aktualisieren
                let totalInvestment = portfolio.totalInvestment
                let totalCoinAmount = portfolio.totalCoinAmount
                
                self.updatePortfolio(
                    totalCash: portfolio.totalCash.rounded(toPlaces: 2),
                    totalInvestment: totalInvestment,
                    coinName: currentCoin.name,
                    coinSymbol: currentCoin.symbol,
                    totalCoinAmount: totalCoinAmount
                )
                completion()
            }
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
            totalCash: totalCash.rounded(toPlaces: 2),
            totalInvestment: totalInvestment,
            lastUpdated: Date(),
            coinName: coinName,
            coinSymbol: coinSymbol,
            totalCoinAmount: totalCoinAmount.rounded(toPlaces: 6)
        )
        //loadPortfolio()
    }
    
    //Investments
    func loadInvestments() {
        self.investments = persistenceController.fetchInvestments()
    }
    
    
    func calculateBitcoinAmount(dollarAmount: Double) -> Double {
        guard let currentBitcoinPrice = coin?.price, currentBitcoinPrice > 0.0 else {
            return 0.0
        }
        return dollarAmount / currentBitcoinPrice
    }
    
    func addInvestment(investmentAmountInDollars: Double, purchaseType: PurchaseType) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        guard let self = self else { return }
        
        do {
            // Validierung: Genügend Cash vorhanden
            guard let portfolio = self.portfolio, portfolio.totalCash >= investmentAmountInDollars else {
                DispatchQueue.main.async {
                    print("Not enough cash to make this investment!")
                }
                return
            }
            if !(investmentAmountInDollars > 0) {
                print("Enter Amount of Money")
                return
            }
            
            // Fetch Coin-Daten
            guard let latestCoin = self.loadCoinSync(), latestCoin.price > 0 else {
                throw NSError(domain: "BuyViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch latest coin data"])
            }
            
            let updatedCoin = latestCoin
            
            
            // Berechnung der Bitcoin-Menge
            let bitcoinAmount = investmentAmountInDollars / updatedCoin.price
            
            
            // Investment speichern
            PersistenceController.shared.saveInvestment(
                coinName: updatedCoin.name,
                coinSymbol: updatedCoin.symbol,
                purchaseType: purchaseType,
                quantity: bitcoinAmount.rounded(toPlaces: 6),
                purchasePrice: updatedCoin.price.rounded(toPlaces: 2),
                date: Date()
            )
            
            // Portfolio aktualisieren
            DispatchQueue.main.async {
                self.portfolio?.totalCash -= investmentAmountInDollars.rounded(toPlaces: 2)
                self.portfolio?.totalInvestment += investmentAmountInDollars.rounded(toPlaces: 2)
                self.portfolio?.totalCoinAmount += bitcoinAmount.rounded(toPlaces: 6)
                self.portfolio = portfolio
                self.refreshPortfolio(){
                    print("Investment added successfully!")
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Failed to add investment: \(error.localizedDescription)")
            }
        }
    }
}
        
    // Synchrone Version von `loadCoin()`
    private func loadCoinSync() -> Coin? {
        let semaphore = DispatchSemaphore(value: 0)
        var fetchedCoin: Coin? = nil
        loadCoin { coin in
            fetchedCoin = coin
            semaphore.signal()
        }
        semaphore.wait()
        return fetchedCoin
    }
}

