//
//  Coin.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import Foundation

struct Coin: Decodable {
    
    let id: String
    let name: String
    let symbol: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case quotes
    }

    enum QuotesCodingKeys: String, CodingKey {
        case USD
    }

    enum USDCodingKeys: String, CodingKey {
        case price
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)

        let quotesContainer = try container.nestedContainer(keyedBy: QuotesCodingKeys.self, forKey: .quotes)
        let usdContainer = try quotesContainer.nestedContainer(keyedBy: USDCodingKeys.self, forKey: .USD)
        price = try usdContainer.decode(Double.self, forKey: .price)
    }
}
