//
//  CoinEntity+CoreDataProperties.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//
//

import Foundation
import CoreData


extension CoinEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinEntity> {
        return NSFetchRequest<CoinEntity>(entityName: "CoinEntity")
    }

    @NSManaged public var price: Double
    @NSManaged public var symbol: String?
    @NSManaged public var name: String?
    @NSManaged public var id: String?

}

extension CoinEntity : Identifiable {

}
