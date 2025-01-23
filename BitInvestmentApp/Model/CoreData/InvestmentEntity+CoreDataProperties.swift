//
//  InvestmentEntity+CoreDataProperties.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//
//

import Foundation
import CoreData

enum PurchaseType: String, Codable {
    case buy = "Buy"
    case sell = "Sell"
}

extension InvestmentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InvestmentEntity> {
        return NSFetchRequest<InvestmentEntity>(entityName: "InvestmentEntity")
    }

    @NSManaged public var investmentCost: Double
    @NSManaged public var date: Date?
    @NSManaged public var purchasePrice: Double
    @NSManaged public var quantity: Double
    @NSManaged public var purchaseType: String
    @NSManaged public var coinSymbol: String?
    @NSManaged public var coinName: String?
    @NSManaged public var id: String

}

extension InvestmentEntity : Identifiable {

}
