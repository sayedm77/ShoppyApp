//
//  AddNewAddressViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import UIKit

class AddNewAddressViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var setDefault: UISwitch!
    var customerId: Int!
    var viewModel = AddNewAddressViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addAddressButton(_ sender: Any) {
        if nameField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""
        && cityField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""
        && phoneField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""
        && addressField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""{
            viewModel.postAddressToApi(customer_id: customerId, name: nameField.text!, phone: phoneField.text!, city: cityField.text!, address: addressField.text!, setDefault: setDefault.isOn)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.dismiss(animated: true)
            }
        } else{
            let alert = UIAlertController(title: "Insufficient Data", message: "Please fill in all the fields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            present(alert, animated: true)
        }
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
