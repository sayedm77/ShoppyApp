//
//  SignInViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 09/09/2024.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    var _firstName, _lastName, _email, _password: String!
    
    let userDefualt = Utilities()
    
    var signInViewModel : SignInViewModel?
    
    var note: String! = "0"
    var navigate: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLoadingData()
    }
    
    func navigateToHome(){
    
        if userDefualt.isLoggedIn() {
            performSegue(withIdentifier: "logIn", sender: self)
        }else {
            print("failed")
            let alert = UIAlertController(title: "Not Authorized", message: "user not exist, please check your email" , preferredStyle: .alert)
            let gotIt = UIAlertAction(title: "Try Again", style: .cancel)
            alert.addAction(gotIt)
            self.present(alert, animated: true)
            
        }
    }
    
    func configureLoadingData(){
        print("configureLoadingData")
        signInViewModel = SignInViewModel()
        print("1")
        signInViewModel?.loadData()
        print("2")
        signInViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                
                print("customers in sign in screen :\n")
                print(self?.signInViewModel?.getAllCustomers()?[0].email ?? "")
                guard let customers = self?.signInViewModel?.getAllCustomers() else {
                    print ("failed to get customers")
                    return
                }
            }
        }
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        signInViewModel?.checkNetworkReachability{ isReachable in
            if isReachable {
                self._email = self.emailText.text
                self._password = self.passwordText.text
                if self.userDefualt.isValidEmail(self._email){
                    if self._password.count >= 6 {
                        for item in (self.signInViewModel?.getAllCustomers())! {
                            
                            let comingMail = item.email ?? ""
                            print(comingMail)
                            if comingMail == self._email{
                                print("matched EMail:\(comingMail)")
                                
                                self.userDefualt.login()
                                self.userDefualt.addId(id: item.id ?? 0)
                                self.userDefualt.addCustomerName(customerName: "\(item.first_name!.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)[0]) \(item.last_name!)")
                                self.userDefualt.setUserPassword(password: item.tags ?? "")
                                self.userDefualt.addCustomerEmail(customerEmail: item.email ?? "")
                                self.userDefualt.setUserNote(note: item.note ?? "")
                                let array = item.note?.components(separatedBy: ",")
                                self.userDefualt.setCartID(cartId: array?[0] ?? "0")
                                print("wishlist:\(self.userDefualt.getWishlistID())")
                                print("cart\(self.userDefualt.getCartID())")
                                self.userDefualt.setWishlistID(wishlistId: array?[1] ?? "0")
                                print("Utilities.utilities.getUserNote()\(Utilities.utility.getUserNote())")
                                
                                self.note = item.note
                                
                                break
                            }
                        }
                        self.navigateToHome()
                    }else{
                        let alert = UIAlertController(title: "Not Authorized", message: "Password should be 6 characters at least" , preferredStyle: .alert)
                        let gotIt = UIAlertAction(title: "Try Again", style: .cancel)
                        alert.addAction(gotIt)
                        self.present(alert, animated: true)
                        self.navigate = false
                    }
                }else{
                    let alert = UIAlertController(title: "Not Authorized", message: "Please enter a valid email" , preferredStyle: .alert)
                    let gotIt = UIAlertAction(title: "Try Again", style: .cancel)
                    alert.addAction(gotIt)
                    self.present(alert, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
   
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
