//
//  AllReviewsViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import UIKit

class AllReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var reviewsTableView: UITableView!
    var reviews : Reviews?
    var Allreviews : [Reviews.Review]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviews = Reviews()
        Allreviews = reviews?.getAllReviews()
        reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewCell")
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        reviewsTableView.reloadData()
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        if segue.identifier == "addReview"{
            _ = storyboard?.instantiateViewController(withIdentifier: "addReview") as? AddReviewViewController
            // Pass the selected object to the new view controller.
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Allreviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        cell.customerName.text = Allreviews?[indexPath.row].customerName
        cell.CreatedAt.text = Allreviews?[indexPath.row].createdAt
        cell.rating.text = String(Allreviews?[indexPath.row].rating ?? 5.0)
        cell.feedback.text = Allreviews?[indexPath.row].massage
        cell.customerImage.image = UIImage(named: Allreviews?[indexPath.row].customerImage ?? "PlaceHolder")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}


