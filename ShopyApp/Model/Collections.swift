//
//  Collections.swift
//  ShopyApp
//
//  Created by sayed mansour on 05/09/2024.
//

import Foundation

struct Collections: Codable {
        var smartCollections: [SmartCollection]

        enum CodingKeys: String, CodingKey {
            case smartCollections = "smart_collections"
        }
    }

    // MARK: - SmartCollection
    struct SmartCollection: Codable {
       
        let title: String
        let image: cImage

        enum CodingKeys: String, CodingKey {
            case title
            case image
        }
    }

    // MARK: - Image
    struct cImage: Codable {
    
        let src: String

        enum CodingKeys: String, CodingKey {
            case src
        }
    }

   
