//
//  ExchangeCurrency.swift
//  ShopyApp
//
//  Created by sayed mansour on 22/09/2024.
//

import Foundation
class ExchangeCurrency {
    static func exchangeCurrency(amount: String?) -> String {
        let result =  Float(amount ?? "0")! * Float(UserDefaults.standard.string(forKey: "factor") ?? "1")!
        return String(format: "%.2f", result)
    }
    
    static func getCurrency() -> String {
        return UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"
    }
}
