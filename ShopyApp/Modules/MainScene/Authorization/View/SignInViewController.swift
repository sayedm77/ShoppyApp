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
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

   
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
