//
//  WishlistViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 17/09/2024.
//

import Foundation
class WishlistViewModel {
    
    var networkHandler:NetworkManager?
    var userDefult : Utilities?
    let model = ReachabilityManager()
    let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties":[]]
    
    var bindWishlistToViewController : (()->()) = {}
    var wishlistResult : [LineItem]?{
        didSet{
            bindWishlistToViewController()
        }
    }
    
    init() {
        self.networkHandler = NetworkManager()
        self.userDefult = Utilities()
        
        
    }
//    
    func loadWishlistData(){
        let apiUrl = APIHandler.urlForGetting(.draftOrder(id: userDefult?.getWishlistID() ?? ""))
        networkHandler?.fetchData(url: apiUrl, type: DraftOrderContainer.self, complitionHandler: { data in
            self.wishlistResult = data?.draftOrder.lineItems
            
        })
    }
    
    func getWishlistData()->[LineItem]{
        return wishlistResult ?? []
    }
    
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
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
                networkHandler?.putInApi(url: APIHandler.urlForGetting(.draftOrder(id:userDefult?.getWishlistID() ?? "")), parameters: ["draft_order": ["line_items": getFilteredItems(items: wishList).count != 0 ? extractLineItemsPostData(lineItems: wishList) : [dummyLineItem]]])
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

