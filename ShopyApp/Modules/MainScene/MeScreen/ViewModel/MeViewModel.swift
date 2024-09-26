//
//  MeViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 16/09/2024.
//

import Foundation
class MeViewModel {
    var networkHandler:NetworkManager?
    var userDefult : Utilities?
    var bindResultToViewController : (()->()) = {}
    var customerItems :[Order]?
    let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties":[]]
    let model = ReachabilityManager()
    var result : Orders?{
         didSet{
             bindResultToViewController()
         }
     }
    var bindWishlistToViewController : (()->()) = {}
    var wishlistResult : [LineItem]?{
         didSet{
             bindWishlistToViewController()
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
    func loadWishlistData(){
        let apiUrl = APIHandler.urlForGetting(.draftOrder(id: userDefult?.getWishlistID() ?? ""))
        networkHandler?.fetchData(url: apiUrl, type: DraftOrderContainer.self, complitionHandler: { data in
            self.wishlistResult = data?.draftOrder.lineItems
      
        })
    }
    func getOrderData(customerId : Int)->[Order]{
        
        self.customerItems = self.result?.orders.filter {
            guard let customer  = $0.customer else {return false}

          return customer.id == customerId
        }
        
        return customerItems ?? []
    }
    func getWishlistData()->[LineItem]{
        return wishlistResult ?? []
     }
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
    func getCustomerId()-> Int{
        return userDefult?.getCustomerId() ?? 0
        
    }
    func getCustomerName()-> String{
        return userDefult?.getCustomerName() ?? ""
        
    }
    func isLoggedIn()->Bool{
        return userDefult?.isLoggedIn() ?? false
    }
    func extractLineItemsPostData(lineItems: [LineItem]) -> [[String: Any]]{
               var result: [[String: Any]] = []
               for item in lineItems{
                   var properties : [[String: String]] = []
                   for property in item.properties {
                       properties.append(["name":property.name, "value": property.value])
                   }
                   result.append(["variant_id": item.variantID as Any, "quantity": item.quantity, "properties": properties])
               }
                       
               return result
           }
           

       func updateWishList(wishList: [LineItem]?){
               guard let wishList = wishList else { return }
               
       //        print(extractLineItemsPostData(lineItems: cartItems))
           networkHandler?.putInApi(url: APIHandler.urlForGetting(.draftOrder(id:"1148537569525")), parameters: ["draft_order": ["line_items": getFilteredItems(items: wishlistResult).count != 0 ? extractLineItemsPostData(lineItems: wishList) : [dummyLineItem]]])
           }
           
       func getFilteredItems(items: [LineItem]?) -> [LineItem]{
               var result: [LineItem] = []
               guard let itmes = items else { return [] }
               print(itmes.count)
               for item in itmes {
                   if item.title ?? "" != "dummy" {
                       result.append(item)
                   }
               }
               print(result.count)
               return result
           }
    
}
