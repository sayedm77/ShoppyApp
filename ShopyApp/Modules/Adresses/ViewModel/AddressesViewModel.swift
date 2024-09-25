//
//  AddressesViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import Foundation
class AddressesViewModel {
    
    var networkManager:NetworkManager?
    var userDefault: Utilities?
    let model = ReachabilityManager()
    var customer_id: Int? // TODO: recieve customer id from previous screen
    var bindResultToViewController : (()->()) = {}
    var customerID: Int?
    var addresses : [Address]? {
        didSet{
            bindResultToViewController()
        }
    }

     init() {
         self.networkManager = NetworkManager()
         userDefault = Utilities()
         customerID = userDefault?.getCustomerId()
         addresses = []
         
     }

  func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
      model.checkNetworkReachability { isReachable in
          completion(isReachable)
      }
  }
    
    func loadData(){
// MARK: - Todo: Put current customer's id
        networkManager?.fetchData(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: String(userDefault?.getCustomerId() ?? 0))), type: Addresses.self, complitionHandler: { result in
            self.addresses = result?.addresses
        })
    }
    
    func deleteAddress(_ index: Int){
        networkManager?.deleteFromApi(url: APIHandler.urlForGetting(.address(customer_id: String(userDefault?.getCustomerId() ?? 0), address_id: String(addresses![index].id))))
    }
    
    func makeDefault(index: Int){
        networkManager?.putInApi(url: APIHandler.urlForGetting(.makeDefaultAddress(customer_id: String(userDefault?.getCustomerId() ?? 0), address_id: String(addresses![index].id))))
    }
    
    func getAddresses() -> [Address]{
        return addresses ?? []
    }
}
