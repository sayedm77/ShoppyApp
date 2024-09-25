//
//  AddressBookViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import UIKit

class AddressBookViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var defaultAddress: UITableView!
    var viewModel = AddressBookViewModel()
    
    var address: [Address]?
    
    var indicator: UIActivityIndicatorView?
    
    var draftId: Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultAddress.dataSource = self
        defaultAddress.delegate = self
        defaultAddress.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "addressBookCell")
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = self.view.center
        self.view.addSubview(indicator!)
    }
    override func viewWillAppear(_ animated: Bool) {
        indicator?.startAnimating()
        viewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                self.viewModel.loadData()
                self.viewModel.bindResultToViewController = {
                    self.address = self.viewModel.getDefaultAddress()
                    self.indicator?.stopAnimating()
                    self.defaultAddress.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if address?.count == 0{
        tableView.setEmptyView(title: "No addresses exist", message: "Go ahead and add an address!")
        }
        else {
        tableView.restore()
        }
        return address?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressBookCell") as! AddressTableViewCell
        cell.nameLabel.text = address?[indexPath.row].name
        cell.cityLabel.text = address?[indexPath.row].city
        cell.addressLabel.text = address?[indexPath.row].address1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "continueToPayment"{
            // Pass the selected object to the new view controller.
            let payment = segue.destination as! PaymentViewController
            payment.draftId = draftId
        }
    }
    

     @IBAction func backButtun(_ sender: Any) {
         dismiss(animated: true)
     }
    
    @IBAction func proceedButton(_ sender: Any) {
        viewModel.addCustomerAddress(draftId: draftId)
        performSegue(withIdentifier: "continueToPayment", sender: nil)
    }
    
}
