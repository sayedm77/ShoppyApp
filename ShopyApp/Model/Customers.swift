//
//  Customers.swift
//  ShopyApp
//
//  Created by sayed mansour on 10/09/2024.
//

import Foundation

struct AllCustomers: Codable{
    let customers: [CustomerModel]?
}

struct Customer: Codable{
    let customer: CustomerModel
}

struct CustomerModel: Codable {
    let first_name, last_name, email, phone, tags: String?
    let id: Int?
    let verified_email: Bool?
    //let addresses: [Address]?
    let note: String?

}
