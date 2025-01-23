//
//  PersistenceController.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BitInvestmentApp")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Löscht bestehende Coins vor dem Speichern eines neuen
    func saveCoin(_ coin: Coin) {
        let context = container.viewContext

        // Vorhandenen Coin löschen
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CoinEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting existing coins: \(error.localizedDescription)")
        }

        // Neuen Coin speichern
        let coinEntity = CoinEntity(context: context)
        coinEntity.id = coin.id
        coinEntity.name = coin.name
        coinEntity.symbol = coin.symbol
        coinEntity.price = coin.price

        saveContext()
    }

    // Gibt den gespeicherten Coin zurück
    func fetchCoin() -> CoinEntity? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()

        do {
            let coins = try context.fetch(fetchRequest)
            return coins.first // Es sollte nur einen Coin geben
        } catch {
            print("Error fetching coin: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Erstellt oder aktualisiert das Portfolio
    func savePortfolio(
        id: String = "portfolio", // Festgelegte ID für das einzige Portfolio
        totalCash: Double,
        totalInvestment: Double,
        lastUpdated: Date,
        coinName: String,
        coinSymbol: String,
        totalCoinAmount: Double
    ) {
        let context = container.viewContext

        // Prüfen, ob das Portfolio existiert
        let fetchRequest: NSFetchRequest<PortfolioEntity> = PortfolioEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try context.fetch(fetchRequest)
            let portfolio = results.first ?? PortfolioEntity(context: context) // Neu erstellen, wenn nicht gefunden

            portfolio.id = id
            portfolio.totalCash = totalCash
            portfolio.totalInvestment = totalInvestment
            portfolio.lastUpdated = lastUpdated
            portfolio.coinName = coinName
            portfolio.coinSymbol = coinSymbol
            portfolio.totalCoinAmount = totalCoinAmount

            saveContext()
        } catch {
            print("Error saving portfolio: \(error.localizedDescription)")
        }
    }
    
    func addMoney(
        id: String = "portfolio",
        moneyAmount: Double
    ){
        let context = container.viewContext

        // Prüfen, ob das Portfolio existiert
        let fetchRequest: NSFetchRequest<PortfolioEntity> = PortfolioEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try context.fetch(fetchRequest)
            let portfolio = results.first ?? PortfolioEntity(context: context) // Neu erstellen, wenn nicht gefunden

            portfolio.id = id
            portfolio.totalCash += moneyAmount
            portfolio.lastUpdated = Date()

            saveContext()
        } catch {
            print("Error saving portfolio: \(error.localizedDescription)")
        }
        
    }

    // Gibt das Portfolio zurück
    func fetchPortfolio() -> PortfolioEntity? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<PortfolioEntity> = PortfolioEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "portfolio") // Festgelegte ID

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching portfolio: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Speichert ein neues Investment
   func saveInvestment(
       coinName: String,
       coinSymbol: String,
       purchaseType: PurchaseType,
       quantity: Double,
       purchasePrice: Double,
       date: Date
   ) {
       let context = container.viewContext

       let investmentCost = quantity * purchasePrice

       let investment = InvestmentEntity(context: context)
       investment.id = UUID().uuidString
       investment.coinName = coinName
       investment.coinSymbol = coinSymbol
       investment.purchaseType = purchaseType.rawValue
       investment.quantity = quantity
       investment.purchasePrice = purchasePrice
       investment.date = date
       investment.investmentCost = investmentCost

       saveContext()
   }

   // Holt alle Investments
   func fetchInvestments() -> [InvestmentEntity] {
       let context = container.viewContext
       let fetchRequest: NSFetchRequest<InvestmentEntity> = InvestmentEntity.fetchRequest()

       do {
           return try context.fetch(fetchRequest)
       } catch {
           print("Error fetching investments: \(error.localizedDescription)")
           return []
       }
   }
    
    func deleteAllInvestments() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = InvestmentEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext() // Änderungen speichern
        } catch {
            print("Error deleting all investments: \(error.localizedDescription)")
        }
    }
}
