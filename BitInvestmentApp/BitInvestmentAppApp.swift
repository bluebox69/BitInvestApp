//
//  BitInvestmentAppApp.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import SwiftUI

@main
struct BitInvestmentAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
