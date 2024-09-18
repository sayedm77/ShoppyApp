//
//  AddReviewViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import UIKit

class AddReviewViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var rate: UISlider!
    @IBOutlet weak var review: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addReview(_ sender: Any) {
       
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
   
}
