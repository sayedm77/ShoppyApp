//
//  SearchViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 11/09/2024.
//

import Foundation
class SearchViewModel {
    var manager : NetworkManager?
    var bindResultToViewcontoller : (()->()) = { }
    var filteredItems :[Product]?
    var results : Products? {
        didSet{
            bindResultToViewcontoller()
        }
    }
    init() {
        manager = NetworkManager.manager
    }

    func loadData (){
        let apiURL = APIHandler.urlForGetting(.products)
        manager?.fetchData(url: apiURL, type: Products.self, complitionHandler: { data in
            self.results = data
        })
        
    }
    
    func getAllData() -> Products{
        return results ?? Products(products: [])
    }
    
    
}
