//
//  PaymentViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import UIKit

class PaymentViewController: UIViewController {
    @IBOutlet weak var methods: UITableView!
    
    @IBOutlet weak var purchaseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func purchase(_ sender: Any) {
// MARK: TODO: make sure that the payment is done(case apple pay)
     
    }
  
}
