//
//  Helper.swift
//  ShopyApp
//
//  Created by sayed mansour on 11/09/2024.
//

import Foundation
class HelperFunctions{
    func convertToDictionary<T: Codable>(object: T,string: String) -> [String: Any]? {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            guard let data = try? encoder.encode(object),
                  let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return nil
            }
            return [string : dictionary]
        }
}
