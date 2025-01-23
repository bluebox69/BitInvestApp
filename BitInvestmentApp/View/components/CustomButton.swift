//
//  CustomButton.swift
//  BitInvestmentApp
//
//  Created by Paul Kogler on 17.01.25.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    var iconName: String


    var body: some View {
        Button(action: action) {
            HStack{
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .padding(.trailing, 4)
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(20)
        }
    }
}
