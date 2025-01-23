//
//  PortfolioEntity+CoreDataProperties.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//
//

import Foundation
import CoreData


extension PortfolioEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortfolioEntity> {
        return NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
    }

    @NSManaged public var totalCoinAmount: Double
    @NSManaged public var coinSymbol: String?
    @NSManaged public var coinName: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var totalInvestment: Double
    @NSManaged public var totalCash: Double
    @NSManaged public var id: String?

}

extension PortfolioEntity : Identifiable {

}
