//
//  CartViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import UIKit

class CartViewController: UIViewController {

    
    @IBOutlet weak var cartItems: UITableView!
    
    @IBOutlet weak var subtotal: UILabel!
    
    @IBOutlet weak var currency: UILabel!
    
    @IBOutlet weak var proceedButton: UIButton!
    
    
    @IBOutlet weak var nonRegisteredView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
//        if cartDidChange{
//            print("Cart Items changed. Updating...")
//            viewModel?.updateOrder(cartItems: cartProducts)
//        }
        dismiss(animated: true)
    }
   
}
