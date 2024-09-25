//
//  PaymentViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import Foundation
import PassKit
class PaymentViewModel {
    
    let paymentMethods = ["Online payment", "Cash on delivery"]
    var networkManager: NetworkManager?
    var flag = false
    var bindResultToViewController: (()->()) = {}
    var draftOrder: DraftOrder? {
        didSet{
            bindResultToViewController()
            flag = true
        }
    }
    var cart: [LineItem]?
    
    let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties":[]]
    
    init(){
        networkManager = NetworkManager()
    }
// MARK: - Awaiting customer's cart id
    func loadData(draftId: Int){
        networkManager?.fetchData(url: APIHandler.urlForGetting(.draftOrder(id: "\(String(draftId))")), type: DraftOrderContainer.self, complitionHandler: { container in
            self.draftOrder = container?.draftOrder
            self.cart = self.draftOrder?.lineItems
        })
    }
    
    func configurePaymentRequest(request: PKPaymentRequest){
        request.merchantIdentifier = "merchant.com.my.shopify.pay"
        request.supportedNetworks = [.masterCard, .visa]
        
        request.supportedCountries = ["EG", "US"]
        request.merchantCapabilities = .threeDSecure
        request.countryCode = "EG"
        request.currencyCode = UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"
    }
    
    func completeOrder(draftId: Int){
        
//        print(extractLineItemsPostData(lineItems: cartItems))
        networkManager?.putInApi(url: APIHandler.urlForGetting(.draftOrder(id: "\(String(draftId))")), parameters: ["draft_order": ["line_items":[dummyLineItem]]])
    }
    
//    let dummyLineItem: [String: Any] = ["title": "dummy", "quantity": 1, "price": "0.0", "properties":[]]
//    parameters: ["draft_order": ["line_items":[dummyLineItem]]]
    
    func postOrder(){
// MARK: - Post order from draftOrder Here
        /* line items same, get discount code from AppliedDiscount, order.createdAt = draft.updatedAt*/
        if flag == false{
            postOrder()
        }else{
            let order = Order(id: 0, lineItems: priceUpdatedCart(getFilteredCart()), createdAt: draftOrder?.updatedAt ?? "", currency: UserDefaults.standard.string(forKey: "currencyTitle") ?? "", currentSubtotalPrice: "", name: "", subtotalPrice: "", totalPrice: "", customer: draftOrder?.customer ?? CustomerModel(first_name: "", last_name: "", email: "", phone: "222", tags: "", id: 0, verified_email: false, note: ""), currentTotalDiscounts: "", totalDiscounts: "",appliedDiscount: draftOrder?.appliedDiscount)
            let parameters = HelperFunctions().convertToDictionary(object: order, string: "order") ?? [:]
            networkManager?.PostToApi(url: APIHandler.urlForGetting(.orders), parameters: parameters)
        }
    }
    
    func getDraftOrder() -> DraftOrder?{
        return draftOrder
    }
    
    func getFilteredCart() -> [LineItem]{
        var result: [LineItem] = []
        guard let cart = cart else { return [] }
        for item in cart {
            if item.title ?? "" != "dummy" {
                result.append(item)
            }
        }
        return result
    }
    
    func priceUpdatedCart(_ cart: [LineItem]) -> [LineItem]{
        var result: [LineItem] = []
        for item in 0...cart.count-1 {
            result.append(cart[item])
            result[item].price = String(UserDefaults.standard.double(forKey: "factor") * (Double(result[item].price) ?? 0.0))
        }
        
        return result
    }
    
    func getOrderTotalPrice() -> Double{
        let cart = getFilteredCart()
        var result: Double = 0
        for item in cart {
            result += UserDefaults.standard.double(forKey: "factor") * Double(item.quantity) * (Double(item.price) ?? 0.0)
        }
        
        return result
    }
   
    
    
    
}
