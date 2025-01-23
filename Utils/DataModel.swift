//
//  DataModel.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 21.01.25.
//

import Foundation

class DataModel {
    
    var notificationReceived = false
    
    init() {
        
        NotificationCenter.default.addObserver(forName: HomeView.reminderNotification, object: nil, queue: nil, using: getDataUpdate)
    }
    
    func getDataUpdate(notification: Notification) {
        print("Notification received!")
        
    }
}
