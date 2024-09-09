//
//  MainViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 09/09/2024.
//

import UIKit

class MainViewController: UIViewController {

    
    var viewModel  = MainViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }

    func showAlert(){
        let alert = UIAlertController(title: "No Internet Connection", message: "Check your Internet and try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        alert.addAction(action)
        self.present(alert, animated: true,completion: nil)

    }

}
