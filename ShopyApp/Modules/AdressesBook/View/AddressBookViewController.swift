//
//  AddressBookViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import UIKit

class AddressBookViewController: UIViewController {

    @IBOutlet weak var defaultAddress: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */

     @IBAction func backButtun(_ sender: Any) {
         dismiss(animated: true)
     }
    
    @IBAction func proceedButton(_ sender: Any) {
    }
    
}
