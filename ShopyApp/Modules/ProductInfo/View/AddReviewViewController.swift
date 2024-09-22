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
    var reviews : Reviews?
    var reviewObj :Reviews.Review?
    var formattedDate : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewObj = Reviews.Review(customerName: "", customerImage: "", createdAt: "", massage: "", rating: 0.0)
        getCurrentDate()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addReview(_ sender: Any) {
        reviewObj?.createdAt = formattedDate ?? "0"
        reviewObj?.customerName = name.text ?? ""
        reviewObj?.massage = review.text ?? ""
        reviewObj?.rating = Double(rate.value)
        reviewObj?.customerImage = "boyIcon"
        Reviews.reviews.append(reviewObj!)
        dismiss(animated: true)
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    func getCurrentDate(){
        let currentDate = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd "

         formattedDate = dateFormatter.string(from: currentDate)
    }
   
}
