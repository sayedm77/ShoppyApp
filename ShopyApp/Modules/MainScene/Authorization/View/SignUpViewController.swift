//
//  SignUpViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 09/09/2024.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var secondName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    var _firstName, _lastName, _email, _password: String!
    let userDefualt = Utilities()
    var signUpViewModel : SignUpViewModel?
    var customers : [CustomerModel]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLoadingData()
        bindToViewModel()
    }
    
    func bindToViewModel(){
        signUpViewModel?.bindNavigate = { [weak self] in
            DispatchQueue.main.async {
                if ((self?.signUpViewModel?.navigateToHome()) == true){
                    self?.navigate()
                }
                else{
                    let alert = UIAlertController(title: "Not Authorized", message: "An Error Occured", preferredStyle: .alert)
                    let gotIt = UIAlertAction(title: "Try Again", style: .cancel)
                    alert.addAction(gotIt)
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    func navigate(){
        if self.signUpViewModel?.navigate == true{
            performSegue(withIdentifier: "toHome", sender: self)
        }else {
            print("failed")
            
        }
    }
    
    func configureLoadingData(){
        print("configureLoadingData")
        signUpViewModel = SignUpViewModel()
        print("1")
        signUpViewModel?.loadData()
        print("2")
        signUpViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.customers = self?.signUpViewModel?.getAllCustomers() ?? []
                print("customers")
                print(self?.customers?[0].email ?? "")
                guard let customers = self?.signUpViewModel?.getAllCustomers() else {
                    return
                }
                self?.customers = customers
                
                
            }
        }
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func signUpButton(_ sender: Any) {
        
        signUpViewModel?.checkNetworkReachability{ isReachable in
            if isReachable {
                self._firstName = self.firstName.text
                self._lastName = self.secondName.text
                self._email = self.emailAddress.text
                self._password = self.password.text
                if self._firstName != "" && self._lastName != ""{
                    if self.userDefualt.isValidEmail(self._email){
                        if self.passwordConfirmation.text == self._password{
                            if self._password.count >= 6{
                                
                                
                                for item in (self.signUpViewModel?.getAllCustomers())! {
                                    let comingMail = item.email ?? ""
                                    if comingMail == self._email{
                                        print("matched EMail:\(comingMail)")
                                        self.signUpViewModel?.flag=true
                                    }
                                }
                                if self.signUpViewModel?.flag == true{
                                    let alert = UIAlertController(title: "Warning", message: "This user already exists", preferredStyle: .alert)
                                    let gotIt = UIAlertAction(title: "Ok", style: .cancel)
                                    let signUp = UIAlertAction(title: "Sign In", style: .default) { UIAlertAction in
                                        self.performSegue(withIdentifier: "toSign", sender: nil)
                                    }
                                    
                                    alert.addAction(signUp)
                                    alert.addAction(gotIt)
                                    self.present(alert, animated: true)
                                    
                                }else{
                                    
                                    
                                    self.signUpViewModel?.registerCustomer(firstName: self._firstName , lastName: self._lastName , email: self._email, password: self._password){ result in
                                        
                                        print("signUp View controller.registerCustomer")
                                        switch result{
                                        case true:
                                            print("from view  \(String(describing: self._firstName ?? ""))")
                                        case false:
                                            DispatchQueue.main.async {
                                                let alert = UIAlertController(title: "Warning", message:"Error in registering" , preferredStyle: .alert)
                                                let gotIt = UIAlertAction(title: "Try Again", style: .cancel)
                                                alert.addAction(gotIt)
                                                self.present(alert, animated: true)
                                            }
                                        }
                                    }
                                }
                            }else{
                                let alert = UIAlertController(title: "Warning", message:"Password must be more than 5 digit" , preferredStyle: .alert)
                                let gotIt = UIAlertAction(title: "Try Again", style: .cancel)
                                alert.addAction(gotIt)
                                self.present(alert, animated: true)
                            }
                        }else{
                            
                            let alert = UIAlertController(title: "Warning", message: "Password Confirmation Doesnt match", preferredStyle: .alert)
                            let gotIt = UIAlertAction(title: "Try Again", style: .cancel)
                            alert.addAction(gotIt)
                            self.present(alert, animated: true)
                            
                        }
                        
                    }else{
                        let alert = UIAlertController(title: "Warning", message: "Please, enter valid email", preferredStyle: .alert)
                        let gotIt = UIAlertAction(title: "Try Again", style: .cancel)
                        alert.addAction(gotIt)
                        self.present(alert, animated: true)
                        
                    }
                }else{
                    let alert = UIAlertController(title: "Warning", message: "Required full name", preferredStyle: .alert)
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
    
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel)
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
