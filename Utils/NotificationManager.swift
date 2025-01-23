//
//  NotificationManager.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 21.01.25.
//

import Foundation
import UserNotifications



class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func schedulePortfolioReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Portfolio Reminder"
        content.body = "Don’t forget to check your Portfolio!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "PortfolioReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling portfolio reminder: \(error.localizedDescription)")
            }
        }
    }
}
