//
//  OrderReviewViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import Foundation
class OrderReviewViewModel {
    var networkManager: NetworkManager?
    var bindResultToViewController: (()->()) = {}
    let model = ReachabilityManager()
    var discounts: [PriceRule]?
    var ruleId = -1
    var cart: [LineItem]? {
        didSet{
            bindResultToViewController()
        }
    }
    
    init(){
        networkManager = NetworkManager()
    }
    func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
        model.checkNetworkReachability { isReachable in
            completion(isReachable)
        }
    }
  // MARK: - Awaiting customer's cart id
      func loadData(draftId: Int){
          networkManager?.fetchData(url: APIHandler.urlForGetting(.draftOrder(id: "\(String(draftId))")), type: DraftOrderContainer.self, complitionHandler: { container in
              self.cart = container?.draftOrder.lineItems
          })
          networkManager?.fetchData(url: APIHandler.urlForGetting(.priceRule), type: PriceRules.self, complitionHandler: { container in
              self.discounts = container?.priceRules
          })
          print("mosalah")
      }
      
      func clearRuleId(){ ruleId = -1 }
      
      func setRuleId(id: Int){ ruleId = id }
      
      
      func check(discountCode: String) -> Double {
          var discountAmount = 0.0
          guard let discounts = discounts else { return discountAmount }
          for rule in 0 ..< discounts.count{
              if discountCode == discounts[rule].title{
                  setRuleId(id: rule)
                  discountAmount = Double(discounts[rule].value) ?? 0.0
                  print("Discount code exixts, amount: \(discountAmount)")
                  break
              }
          }
          
          print("if nothing above, not available")
          return discountAmount
  //        guard let cartItems = cartItems else { return }
  //
  ////        print(extractLineItemsPostData(lineItems: cartItems))
  //        networkManager?.putInApi(url: APIHandler.urlForGetting(.draftOrder(id: "\(String(dummyDraftId))")), parameters: ["draft_order": ["line_items": extractLineItemsPostData(lineItems: cartItems)]])
      }
      
      func convertRuleToDiscount(rule: PriceRule) -> [String: Any]{
          var result: [String: Any] = [:]
          result["title"] = rule.title
          result["value"] = rule.value
          result["value_type"] = rule.valueType
          return result
      }
      
      func putDiscount(draftId: Int){
          if ruleId > -1 {
              print(convertRuleToDiscount(rule: discounts![ruleId]))}
          networkManager?.putInApi(url: APIHandler.urlForGetting(.draftOrder(id: "\(String(draftId))")), parameters: ["draft_order": ["applied_discount": (ruleId > -1 ? convertRuleToDiscount(rule: discounts![ruleId]) : nil) ]])
          
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
    
    
    
}
