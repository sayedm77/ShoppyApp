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
    
    
    func sortProductsByPriceAscending() {
          self.filteredResult = self.result?.products.sorted {
              guard let price1 = Double($0.variants.first?.price ?? "0"),
                    let price2 = Double($1.variants.first?.price ?? "0") else {
                  return false
              }
              return price1 < price2
          } ?? []
          
          bindResultToViewController() // Bind data after sorting
      }

      // Get all products for a specific vendor
      func getAllData(vendor: String) -> [Product] {
          self.filteredResult = self.result?.products.filter {
              $0.vendor == vendor
          } ?? []
          
          bindResultToViewController() // Bind data after filtering
          return filteredResult ?? []
      }
      
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}
