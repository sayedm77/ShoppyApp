//
//  MainViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 09/09/2024.
//

import Foundation
class MainViewModel{
    
    let reachabilityHandler = ReachabilityManager()
    
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        reachabilityHandler.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}
