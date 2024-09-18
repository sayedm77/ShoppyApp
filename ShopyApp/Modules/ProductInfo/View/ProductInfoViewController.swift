//
//  ProductInfoViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import UIKit

class ProductInfoViewController: UIViewController {
    
    @IBOutlet weak var color: UIButton!
    
    @IBOutlet weak var size: UIButton!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var productNameText: UITextView!
    
    @IBOutlet weak var productRateText: UILabel!
    
    @IBOutlet weak var productPriceText: UILabel!
    
    @IBOutlet weak var productCurrencyText: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var addToFavButton: UIButton!
    
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var star2: UIImageView!
    
    @IBOutlet weak var star3: UIImageView!
    
    @IBOutlet weak var star4: UIImageView!
    
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var cover: UIView!
    
    @IBOutlet weak var descriptionText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addingToCart(_ sender: Any) {
    }
    @IBAction func addingToWishlist(_ sender: Any) {
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }

}
