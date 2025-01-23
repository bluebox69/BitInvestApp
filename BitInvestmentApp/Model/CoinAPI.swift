//
//  CoinAPI.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//
import Foundation

class APIService: ObservableObject {
    func fetchCoin(completion: @escaping (Coin?) -> Void) {
        guard let url = URL(string: "https://api.coinpaprika.com/v1/tickers/btc-bitcoin") else {
            print("URL invalid")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Cannot open URL! System error \(error!.localizedDescription)")
                completion(nil)
                return
            }

            guard let responseData = data else {
                print("Received data was nil.")
                completion(nil)
                return
            }

            do {
                let coin = try JSONDecoder().decode(Coin.self, from: responseData)
                completion(coin)
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}
