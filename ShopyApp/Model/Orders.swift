//
//  Orders.swift
//  ShopyApp
//
//  Created by sayed mansour on 16/09/2024.
//

import Foundation

// MARK: - Welcome
struct Orders: Codable {
    var orders: [Order]
}

// MARK: - Order
struct Order: Codable {
    let id: Int
    let lineItems: [LineItem]
    let createdAt: String
    let currency: String
    let currentSubtotalPrice: String
    let name: String
    let subtotalPrice: String
    let totalPrice: String
    let customer: CustomerModel
    let currentTotalDiscounts: String
    let totalDiscounts: String
    let appliedDiscount: AppliedDiscount?

   
    enum CodingKeys: String, CodingKey {
        case id
        case lineItems = "line_items"
        case createdAt = "created_at"
        case currency
        case currentSubtotalPrice = "current_subtotal_price"
        case name
        case totalDiscounts = "total_discounts"
        case customer
        case currentTotalDiscounts = "current_total_discounts"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case appliedDiscount = "applied_discount"

        
      
    }
}
struct LineItem: Codable {
    let id: Int
    let variantID, productID: Int?
    var price: String
    let name, title: String?
    var quantity: Int
    let properties: [NoteAttribute]


    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case productID = "product_id"
        case name, price, title
        case quantity, properties
        
    }
}
