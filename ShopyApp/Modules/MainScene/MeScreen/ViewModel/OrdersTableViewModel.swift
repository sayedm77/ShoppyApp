//
//  OrdersTableViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import Foundation
class OrdersTableViewModel {
    
    var networkHandler:NetworkManager?
    var userDefult : Utilities?
    var bindResultToViewController : (()->()) = {}
    var customerItems :[Order]?
    let model = ReachabilityManager()
    var result : Orders?{
         didSet{
             bindResultToViewController()
         }
     }
     
     init() {
         self.networkHandler = NetworkManager()
         self.userDefult = Utilities()
         customerItems = []
         
     }
    
     func loadData(){
         let apiUrl = APIHandler.urlForGetting(.orders)
         networkHandler?.fetchData(url: apiUrl, type: Orders.self, complitionHandler: { data in
             self.result = data
       
         })
         
         
     }
    
    func getAllData(customerId : Int)->[Order]{
       
        self.customerItems = self.result?.orders.filter{
            $0.customer.id == customerId
         } ?? []
      
         return customerItems ?? []
     }
    func getCustomerId()-> Int{
        return userDefult?.getCustomerId() ?? 0
        
    }
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
}

