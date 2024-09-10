//
//  Utilities.swift
//  ShopyApp
//
//  Created by sayed mansour on 10/09/2024.
//

import Foundation
class Utilities {
    
    static let utility = Utilities()
    

        
        func addCustomerId(id: Int){
            UserDefaults.standard.set(id, forKey: "id")
        }
        
        func getCustomerId()->Int{
            return UserDefaults.standard.value(forKey: "id") as? Int ?? 0
        }
        
        func addCustomerName(customerName: String){
            UserDefaults.standard.set(customerName, forKey: "name")
        }
        
        func getCustomerName()-> String{
            return UserDefaults.standard.value(forKey: "name") as? String ?? ""
        }
        
        func addCustomerEmail(customerEmail: String){
            UserDefaults.standard.set(customerEmail, forKey: "email")
        }
        
        func getCustomerEmail()-> String{
            return UserDefaults.standard.value(forKey: "email") as? String ?? ""
        }
        
        func isFirstTimeInApp() ->Bool {
            return UserDefaults.standard.bool(forKey: "isFirst")
        }
        
        func saveDiscountCode(code:String) {
            UserDefaults.standard.set(code, forKey: "code")
        }
        
        func isCodeUsed(code:String) ->Bool {
            return UserDefaults.standard.bool(forKey: "\(code)")
        }
        
        func setCodeUsed(code:String,isUsed:Bool) {
            UserDefaults.standard.set(isUsed, forKey: "\(code)")
        }
        
       
        func getCode() ->String {
            return UserDefaults.standard.value(forKey: "coupon") as? String ?? ""
        }
        
        func setCode(code:String) {
            UserDefaults.standard.set(code, forKey: "coupon")
        }
        
        func setIsFirstTimeInApp(){
            UserDefaults.standard.set(true, forKey: "isFirst")
        }
        
        func isLoggedIn() -> Bool {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
        
        func login() {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
        func logout() {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.set(0, forKey: "id")
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set("", forKey: "wishlistId")
            UserDefaults.standard.set("", forKey: "cartId")
        }
        
        func addId(id: Int) {
            UserDefaults.standard.set(id, forKey: "id")
        }
        func getId()->Int {
            return UserDefaults.standard.value(forKey: "id") as? Int ?? 0
        }
        func setDiscountCode(code:String){
            UserDefaults.standard.set(code ,forKey: "code")
        }
        func getDiscountCode() -> String {
            return UserDefaults.standard.value(forKey: "code") as? String ?? ""

        }
        func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            print("\(email) \(emailPred.evaluate(with: email))")
            return emailPred.evaluate(with: email)
        }
        func checkUserIsLoggedIn(completion: @escaping (Bool) -> Void){
            if isLoggedIn() {
                completion(true)
            }else{
                completion(false)
            }
        }
        
        func setCurrency(Key: String, value: String){
            UserDefaults.standard.set(value, forKey: Key)
            
        }
        func getCurrency(key: String = "currency")-> String{
            let currency = UserDefaults.standard.string(forKey: key)
            if currency == ""{
                return "USD"
            }
            return currency ?? ""
            
        }
        func setDraftOrder(id:Int){
            UserDefaults.standard.set(id, forKey: "draft_order_id")
        }
        func getDraftOrder()->Int{
            UserDefaults.standard.value(forKey: "draft_order_id") as! Int
        }
        func setUserPassword(password:String){
            UserDefaults.standard.set(password, forKey: "password")
        }
        func getUserPassword()->String{
            UserDefaults.standard.value(forKey: "password") as! String
        }
        func setUserNote(note:String){
            UserDefaults.standard.set(note, forKey: "note")
        }
        func getUserNote()->String{
            UserDefaults.standard.value(forKey: "note") as! String
        }
        func setWishlistID(wishlistId:String){
            UserDefaults.standard.set(wishlistId, forKey: "wishlistId")
        }
        func getWishlistID()->String{
            UserDefaults.standard.value(forKey: "wishlistId") as! String
        }
        func setCartID(cartId:String){
            UserDefaults.standard.set(cartId, forKey: "cartId")
        }
        
        func getCartID()->String{
            UserDefaults.standard.value(forKey: "cartId") as! String
        }
        func setTotalPrice(totalPrice:Double){
            UserDefaults.standard.set(totalPrice, forKey: "Total_Price")
        }
        func getTotalPrice()->Double{
            return UserDefaults.standard.value(forKey: "Total_Price") as? Double ?? 0
        }
    }

    

