//
//  AddNewAddressViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import Foundation
class AddNewAddressViewModel {
    
    var networkManager: NetworkManager?
    var userDefault: Utilities?
    var helper: HelperFunctions?

    init() {
        self.networkManager = NetworkManager()
        userDefault = Utilities()
        self.helper = HelperFunctions()
    }
    
    func postAddressToApi(customer_id: Int,name: String, phone: String, city: String, address: String, setDefault: Bool){
        networkManager?.PostToApi(url: APIHandler.urlForGetting(.allAddressesOf(customer_id: String(userDefault?.getCustomerId() ?? 0))), parameters: ["address":["name":name,"phone":phone, "address1": address, "city": city, "default": setDefault]])
    }
    
    
    
}
