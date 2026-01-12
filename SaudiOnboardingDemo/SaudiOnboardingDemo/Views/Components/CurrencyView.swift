//
//  CurrencyView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

// MARK: - Currency View with SAR Logo
struct CurrencyView: View {
    let size: CGFloat
    let color: Color
    
    init(size: CGFloat = 18, color: Color = .primary) {
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Image("sar_logo")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(color)
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
}

// MARK: - Currency Text View (Amount + Logo)
struct CurrencyText: View {
    let amount: String
    let amountSize: CGFloat
    let logoSize: CGFloat
    let color: Color
    let weight: Font.Weight
    
    init(
        amount: String,
        amountSize: CGFloat = 18,
        logoSize: CGFloat? = nil,
        color: Color = .primary,
        weight: Font.Weight = .regular
    ) {
        self.amount = amount
        self.amountSize = amountSize
        self.logoSize = logoSize ?? (amountSize * 0.8)
        self.color = color
        self.weight = weight
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(amount)
                .font(.system(size: amountSize, weight: weight))
                .foregroundColor(color)
            
            CurrencyView(size: logoSize, color: color)
        }
    }
}

// MARK: - Preview
struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CurrencyView(size: 24, color: .primary)
            
            CurrencyText(
                amount: "124,500",
                amountSize: 48,
                color: .white,
                weight: .bold
            )
            
            CurrencyText(
                amount: "24,500",
                amountSize: 22,
                color: .primary,
                weight: .bold
            )
        }
        .padding()
        .background(Color.black)
    }
}
