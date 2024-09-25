//
//  SettingsViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 25/09/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var settings: UITableView!
    
    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToSettings(unwindSegue: UIStoryboardSegue){}
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        // TODO: - Write here logout logic
     //   viewModel?.logUserOut()
        dismiss(animated: true)
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
