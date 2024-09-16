//
//  ExchangeRates.swift
//  ShopyApp
//
//  Created by sayed mansour on 16/09/2024.
//

import Foundation

// MARK: - ExchangeRates
struct ExchangeRates: Codable {
    let success: Bool
    let timestamp: Int
    let source: String
    let quotes: [String: Double]
}
