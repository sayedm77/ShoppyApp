//
//  AllReviewsViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import UIKit

class AllReviewsViewController: UIViewController {
    @IBOutlet weak var reviewsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
