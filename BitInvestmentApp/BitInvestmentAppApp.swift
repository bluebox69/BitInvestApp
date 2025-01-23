//
//  BitInvestmentAppApp.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import SwiftUI
import UserNotifications

@main
struct BitInvestmentAppApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        requestNotificationAuthorization()
    }

    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
        } 
    }
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            } else {
                print("Notification permissions granted: \(granted)")
            }
        }
    }
}
