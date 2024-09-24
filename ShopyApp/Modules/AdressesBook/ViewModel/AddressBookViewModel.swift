//
//  AddressBookViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import Foundation
class AddressBookViewModel {
    
    var networkManager:NetworkManager?
    var userDefault: Utilities?
    let model = ReachabilityManager()
    var customerID :Int? // TODO: recieve customer id from current User (if found)
    var bindResultToViewController : (()->()) = {}
    var defaultAddress : [Address]? {
        didSet{
            bindResultToViewController()
        }
    }

     init() {
         self.networkManager = NetworkManager()
         userDefault = Utilities()
         customerID = userDefault?.getCustomerId()
     }

  func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
      model.checkNetworkReachability { isReachable in
          completion(isReachable)
      }
  }
    
    func loadData(){
// MARK: - Todo: Put current customer's id
        networkManager?.fetchData(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: String(customerID ?? 0))), type: Addresses.self, complitionHandler: { result in
            guard let addresses = result?.addresses else {
                self.defaultAddress = []
                return }
            if addresses.count == 0 { self.defaultAddress = []; return }
            for address in addresses{
                if address.addressDefault {
                    self.defaultAddress = [address]
                    break
                }
            }
        })
    }
    
    
    func addCustomerAddress(draftId: Int){
//        print(HelperFunctions().convertToDictionary(object: (defaultAddress![0]), String: "shipping_address"))
        print("updating address....")
        networkManager?.putInApi(url: APIHandler.urlForGetting(.draftOrder(id: "\(String(draftId))")), parameters:["draft_order": ["customer": ["id": defaultAddress?[0].customerID]]])
    }
    
    func getDefaultAddress() -> [Address]{
        return defaultAddress ?? []
    }
    
}
