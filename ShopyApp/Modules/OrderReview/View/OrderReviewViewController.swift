//
//  OrderReviewViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import UIKit

class OrderReviewViewController: UIViewController {

    
    @IBOutlet weak var itemsCollection: UICollectionView!
    
    @IBOutlet weak var subTotal: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var discountField: UITextField!
    
    @IBOutlet weak var applyDiscountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func applyDiscount(_ sender: Any) {
    }
    
    @IBAction func proceedToAddress(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
