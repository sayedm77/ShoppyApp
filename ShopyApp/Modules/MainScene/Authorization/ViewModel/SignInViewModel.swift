//
//  SignInViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 09/09/2024.
//

import Foundation

class SignInViewModel{
    var networkHandler:NetworkManager?
    let model = ReachabilityManager()
    let userDefualt = Utilities()
    var bindResultToViewController : (()->()) = {}
    
    init() {
        self.networkHandler = NetworkManager()
    }
    var listOfCustomer : [CustomerModel]?{
        didSet{
            bindResultToViewController()
        }
    }
    func getAllCustomers()-> [CustomerModel]?{
        return listOfCustomer
    }
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
    //https://a73c5fc1c095fd186d957dd2093e9006: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@q2-24-team2.myshopify.com/admin/api/2024-01/draft_orders.json
    //draft_orders.json
    func loadData() {
        let apiUrl = "https://a73c5fc1c095fd186d957dd2093e9006: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@q2-24-team2.myshopify.com/admin/api/2024-01/customers.json?since_id=1"
        print(apiUrl)
        networkHandler?.fetchData(url: apiUrl, type: AllCustomers.self,complitionHandler:  { data in
            //print("the data from fetching all customers\(data?.customers?.count ?? 0)")
            if let data = data{
                self.listOfCustomer = data.customers
                print("no of customers in load data\(self.listOfCustomer?.count ?? 0)")
            }else {
                print("error in getting all customers")
                
            }
        }, headers: [
            "Cookie":"",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ])
    }
    
    func checkDraftOrderInUser(){}
    
   
    
}
