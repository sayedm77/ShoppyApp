//
//  API.swift
//  ShopyApp
//
//  Created by sayed mansour on 05/09/2024.
//

import Foundation


class APIHandler{
    static let ssl = "https://"
    static let storeURL = "ios-q1-new-capital-2023.myshopify.com"
    static let accessToken = "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"
    static let apiKey = "9ec35bc5ffc50f6db2fd830b0fd373ac"
    static let apiSecretKey = "dfd0e137695430eb82bc3bc3edbc3a30"
    
    // https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@
//    ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json
    static let currencyApiKey = "dY9QLpBRjobREEQ1uh054fpWULwTak3A"
    static let currencyApiURL = "api.apilayer.com/currency_data"
    
    enum EndPoints {
        case priceRule
        case priceRules(id: String)
        case customers
        case Customer(id: String)
        case allAddressesOf(customer_id: String)
        case address(customer_id: String, address_id: String)
        case makeDefaultAddress(customer_id: String, address_id: String)
        case orders
        case order(id: String)
        case products
        case draftOrders
        case draftOrder(id: String)
        case discountCode
        case CollectionID(id:String)
        case ProductDetails(id:String)
        case ProductReviews(id:String)
        case SmartCollections
        case shopConfiguration
        case liveCurrencies(wantedCurrencies: String)
        case listOfAllCurrencies
        var order:String{
            switch self{
            case .priceRule:
                return "price_rules.json"
            case .priceRules(id: let id):
                return "price_rules/\(id).json"
            case .customers:
                return"customers.json?since_id=1"
            case .Customer(id: let id):
                return "customers/\(id).json"
            case .allAddressesOf(customer_id: let customer_id):
                return "customers/\(customer_id)/addresses.json"
            case .address(customer_id: let customer_id, address_id: let address_id):
                return "customers/\(customer_id)/addresses/\(address_id).json"
            case .makeDefaultAddress(customer_id: let customer_id, address_id: let address_id):
                return "customers/\(customer_id)/addresses/\(address_id)/default.json"
            case .orders:
                return "orders.json"
            case .order(id: let id):
                return "orders/\(id).json"
            case .products:
                return "products.json"
            case .draftOrders:
                return "draft_orders.json"
            case .draftOrder(id: let id):
                return "draft_orders/\(id).json"
            case .discountCode:
                return "discount_codes.json"
            case .CollectionID(id: let collectionId):
                return "products.json?collection_id=\(collectionId)"
            case .ProductDetails(id: let productId):
                return "products/\(productId).json"
            case .ProductReviews(id: let productId):
                return "products/\(productId)/resource_feedback.json"
            case .SmartCollections:
                return "smart_collections.json"
            case .shopConfiguration:
                return "shop.json"
            case .liveCurrencies(wantedCurrencies: let wantedCurrencies):
                return "live?source=usd&currencies=\(wantedCurrencies)"
            case .listOfAllCurrencies:
                return "list"
                
            }
        }
    }
    
    enum Completions: String{
        case ssl = "https://"
        case api_version = "2023-10"
    }
    
    class func urlForGetting(_ endpoint: EndPoints) -> String {
        return "\(Completions.ssl.rawValue)\(apiKey):\(accessToken)@\(storeURL)/admin/api/\(Completions.api_version.rawValue)/\(endpoint.order)"
    }
    
    class func currenciesUrl(_ endpoint: EndPoints) -> String {
        return "\(Completions.ssl.rawValue)\(currencyApiURL)/\(endpoint.order)"
    }
}

