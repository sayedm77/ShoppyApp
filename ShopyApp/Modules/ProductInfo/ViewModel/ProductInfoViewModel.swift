//
//  ProductInfoViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import Foundation
class ProductInfoViewModel{
    let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties":[]]
    var networkHandler:NetworkManager?
    
    var userDefaults : Utilities?
    
    var bindResultToViewController : (()->()) = {}
    
    var product : Product?{
        didSet{
            bindResultToViewController()
        }
    }
    
    var currentWishList: [LineItem]? {
        didSet {
            bindResultToViewController()
        }
    }
    var currentCart: [LineItem]?{
        didSet{
            bindResultToViewController()
        }
    }
    let model = ReachabilityManager()
    
    init(){
        networkHandler = NetworkManager()
        userDefaults = Utilities()
    }
    
    
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
    func getProductDetails()-> Product?{
        return product
    }
    func getProductImages()-> [ProductImage]{
        return product?.images ?? []
    }
    func getImagesCount()-> Int{
        print(product?.images.count ?? 0)
        return product?.images.count ?? 0
    }
    
    func loadData(productId:Int){
        let apiUrl = APIHandler.urlForGetting(.ProductDetails(id: String(productId)))
        print(apiUrl)
        networkHandler?.fetchData(url: apiUrl, type: ProductContainer.self, complitionHandler: { data in
            self.product = data?.product
            print(self.product?.title ?? "default value")
        })
        networkHandler?.fetchData(url: APIHandler.urlForGetting(.draftOrder(id: self.userDefaults?.getWishlistID() ?? "")), type: DraftOrderContainer.self, complitionHandler: { container in
            self.currentWishList = container?.draftOrder.lineItems
            print("wishList is here: \(self.userDefaults?.getWishlistID() ?? "")")
        })
        
        networkHandler?.fetchData(url: APIHandler.urlForGetting(.draftOrder(id: self.userDefaults?.getCartID() ?? "")), type: DraftOrderContainer.self, complitionHandler: { container in
            self.currentCart = container?.draftOrder.lineItems
            
        })
    }
    
    
    
    func extractLineItemsPostData(lineItems: [LineItem]) -> [[String: Any]]{
        var result: [[String: Any]] = []
        for item in lineItems{
            var properties : [[String: String]] = []
            for property in item.properties {
                properties.append(["name":property.name, "value": property.value])
            }
            result.append(["variant_id": item.variantID as Any, "quantity": item.quantity, "properties": properties, "product_id": (item.productID ?? 0) as Int])
        }
        
        return result
    }
    
    
    func isInCart(variantId: Int) -> Bool {
        var inCart = false
        for item in getFilteredCart(){
            if item.variantID == variantId {
                inCart = true
                break
            }
        }
        return inCart
    }
    
    func isInLocalWishList(wishList: [[String: Any]], productId: Int) -> Bool {
        var inLocalWishList = false
        for item in wishList{
            if let id = item["product_id"] as? Int {
                if id == productId { inLocalWishList = true; break }
            }
        }
        return inLocalWishList
    }
    
    func isInWishList(productId: Int) -> Bool {
        var inWishList = false
        guard let wishList = currentWishList else {return inWishList}
        for item in wishList{
            if item.productID == productId {
                inWishList = true
                break
            }
        }
        return inWishList
    }
    func addToCart(item: [String:Any]){
        
        var cart = extractLineItemsPostData(lineItems: currentCart ?? [])
        cart.append(item)
        networkHandler?.putInApi(url: APIHandler.urlForGetting(.draftOrder(id: self.userDefaults?.getCartID() ?? "")), parameters: ["draft_order": ["line_items": getFilteredCart().count != 0 ? cart : [item]]])
    }
    
    func updateWishList(wishList: [[String: Any]]?){
        guard let wishList = wishList else { return }
        networkHandler?.putInApi(url: APIHandler.urlForGetting(.draftOrder(id: self.userDefaults?.getWishlistID() ?? "")), parameters: ["draft_order": ["line_items": getFilteredWishList(items: wishList).count != 0 ? getFilteredWishList(items: wishList) : [dummyLineItem]]])
    }
    
    func getWishlist() -> [LineItem] {
        return currentWishList ?? []
    }
    func getFilteredWishList(items: [[String: Any]]) -> [[String: Any]]{
        var result: [[String: Any]] = []
        for item in items {
            if let id = item["variant_id"] as? Int {
                result.append(item)
            }
        }
        print(result.count)
        return result
    }
    func getFilteredCart() -> [LineItem]{
        var result: [LineItem] = []
        guard let cart = self.currentCart else { return [] }
        print(cart.count)
        for item in cart {
            if item.title ?? "" != "dummy" {
                result.append(item)
            }
        }
        print(result.count)
        return result
    }
    
}
