//
//  TopBar.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 18.01.25.
//

import SwiftUI

struct TopBar: View {
    var title: String
    var iconName: String


    var body: some View {
        ZStack {
            Color.black
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .ignoresSafeArea(edges: .top)
            
            ZStack {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .offset(x: -60, y: 0)
                    .foregroundColor(.lightBlue)
                    
                
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.lightYellow)
                    .padding(.leading, 20)

            }
        }
        .frame(height: 60)
    }
}
