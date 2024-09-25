//
//  HomeViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 04/09/2024.
//

import Foundation

class HomeViewModel{
    var userDefult : Utilities?
    var manager: NetworkManager?
    let reachabilityHandler = ReachabilityManager()
    var bindBrandsResultToViewController : (()->()) = {}
    var Brandsresult :Collections? {
        didSet{
            bindBrandsResultToViewController()
        }
    }
    var bindAdsResultToViewController : (()->()) = {}
    var Adsresult :PriceRules? {
        didSet{
            bindAdsResultToViewController()
        }
    }
    init(){
        manager = NetworkManager.manager
        self.userDefult = Utilities()
    }
    
    func loadBrandCollectionData(){
        let apiUrl = APIHandler.urlForGetting(.SmartCollections)
       manager?.fetchData(url: apiUrl, type: Collections.self, complitionHandler: { data in
            self.Brandsresult = data
      
        })
    }
    
    func loadAdsCollectionData(){
        let apiUrl = APIHandler.urlForGetting(.priceRule)
        manager?.fetchData(url: apiUrl, type: PriceRules.self, complitionHandler: { data in
            self.Adsresult = data
            print("sssse")
        })
    }
    
    func getBrandsData()-> [SmartCollection]{
        return Brandsresult?.smartCollections ?? []
    }
    
    func getAdsData()->PriceRules{
        return Adsresult ?? PriceRules(priceRules: [])
    }

    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        reachabilityHandler.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
    func isLoggedIn()->Bool{
        return userDefult?.isLoggedIn() ?? false
    }
}
