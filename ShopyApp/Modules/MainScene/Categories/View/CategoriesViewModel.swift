//
//  CategoriesViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 07/09/2024.
//

import Foundation

class CategoriesViewModel{
    
    var networkHandler:NetworkManager?
    var bindResultToViewController : (()->()) = {}
    var filteredResult : [Product]?
    var men :[Product]?
    var women :[Product]?
    var kid :[Product]?
    let model = ReachabilityManager()
    var result : Products?{
         didSet{
             bindResultToViewController()
         }
     }
     
     init() {
         self.networkHandler = NetworkManager()
         men = []
         women = []
         kid = []
         
     }
    
    func loadData(){
        let apiUrl = APIHandler.urlForGetting(.products)
        networkHandler?.fetchData(url: apiUrl, type: Products.self, complitionHandler: { data in
            self.result = data
            self.filterResult()
      
        })
        
        
    }
    private func filterResult(){
        for item in result?.products ?? []{
            let components = item.tags.components(separatedBy: ",")
            if components.contains(" men"){
                men?.append(item)
            }else if components.contains(" women"){
                women?.append(item)
            }else if components.contains(" kid"){
                kid?.append(item)
            }
        }
    }
    func getAllData()->[Product]{
        
        return result?.products ?? []
     }
    func getWomenData()->[Product]{
        
        return women ??  []
     }
    func getMenData()->[Product]{
        
        return men ?? []
     }
    func getKidsData()->[Product]{
        
        return kid ?? []
     }
    
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}
