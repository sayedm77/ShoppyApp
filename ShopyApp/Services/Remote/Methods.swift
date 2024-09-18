//
//  Methods.swift
//  ShopyApp
//
//  Created by sayed mansour on 05/09/2024.
//

import Foundation

enum Methods {

    case GET
    case POST
    case PUT
    case DELETE
}

enum ErrorType: Error {
    case internalError
    case serverError
    case parsingError
    case urlBadFormmated
}
