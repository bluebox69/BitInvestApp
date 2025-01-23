//
//  MainTabView.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        VStack {
            TopBar(title: " itInvest", iconName: "Vector")
            
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image("HomeTrendUp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text(NSLocalizedString("Home", comment: "HomeTab"))
                        }
                    }
                
                BuyView()
                    .tabItem {
                        Image("WalletAdd")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(NSLocalizedString("buy", comment: "BuyTab"))
                    }
                
                SellView()
                    .tabItem {
                        Image("EmptyWallet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(NSLocalizedString("sell", comment: "SellTab"))
                    }
                SettingsView()
                    .tabItem {
                        Image("Setting3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(NSLocalizedString("settings", comment: "SettingsTab"))
                    }
            }
        }
    }
}
