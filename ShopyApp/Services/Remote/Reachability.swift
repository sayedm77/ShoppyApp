//
//  Reachability.swift
//  ShopyApp
//
//  Created by sayed mansour on 05/09/2024.
//

import Foundation
import Alamofire

class ReachabilityManager {
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        let reachabilityManager = NetworkReachabilityManager()
        completion(reachabilityManager?.isReachable ?? false)
    }
}
