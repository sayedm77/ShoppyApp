//
//  BrandsViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 15/09/2024.
//

import Foundation

class BrandsViewModel{
    
    var networkHandler:NetworkManager?
    var bindResultToViewController : (()->()) = {}
    var filteredResult : [Product]?
    var sortedProducts : [Product]?
    let model = ReachabilityManager()
    var result : Products?{
         didSet{
             bindResultToViewController()
         }
     }
     
     init() {
         self.networkHandler = NetworkManager()
         
         
     }
    
    
    
    func loadData(){
        let apiUrl = APIHandler.urlForGetting(.products)
        networkHandler?.fetchData(url: apiUrl, type: Products.self, complitionHandler: { data in
            self.result = data
    
        })
        
        
    }
    
    
    func sortByPrice() {
        filteredResult = filteredResult?.sorted {Double($0.variants.first?.price ?? "0.0") ?? 0.0  < Double($1.variants.first?.price ?? "0.0")  ?? 0.0 }
        }

      // Get all products for a specific vendor
      func getAllData(vendor: String) {
          self.filteredResult = self.result?.products.filter {
              $0.vendor == vendor
          } ?? []
          
      }
      
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}
