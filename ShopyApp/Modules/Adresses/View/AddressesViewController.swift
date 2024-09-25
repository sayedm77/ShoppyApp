//
//  AddressesViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import UIKit

class AddressesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addresses: UITableView!
    var viewModel = AddressesViewModel()
    
    var addressesList: [Address]?
    
    var indicator : UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addresses.delegate = self
        addresses.dataSource = self
        addresses.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "addressCell")
        indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        self.view.addSubview(indicator!)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                self.addresses.reloadData()
                self.indicator.startAnimating()
                self.refreshTable()
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
    
    func refreshTable(){
//        MARK: - ADD CUSTOMER'S ID
        Thread.sleep(forTimeInterval: 0.2)
        viewModel.loadData()
        viewModel.bindResultToViewController = { [weak self] in
            self?.addressesList = self?.viewModel.addresses
//            print(self?.addressesList)
            self?.indicator.stopAnimating()
            self?.addresses.reloadData()
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if addressesList?.count == 0{
        tableView.setEmptyView(title: "No addresses added yet", message: "Go ahead and add an address!")
        }
        else {
        tableView.restore()
        }
        
        return (addressesList?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as! AddressTableViewCell
        cell.nameLabel.text = addressesList?[indexPath.row].name
        cell.cityLabel.text = addressesList?[indexPath.row].city
        cell.addressLabel.text = addressesList?[indexPath.row].address1
        if addressesList?[indexPath.row].addressDefault == true {
            cell.isDefault.isHidden = false
        } else {
            cell.isDefault.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddressTableViewCell
        if cell.isDefault.isHidden {
            let setAddressAlert = UIAlertController(title: "Set Primary", message: "Do you want to set this address as your primary adderss?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .cancel) { UIAlertAction in
                //MARK: - TODO: save as default address (PUT)
                self.indicator.startAnimating()
                self.viewModel.makeDefault(index: indexPath.row)
                self.refreshTable()
            }
            let no = UIAlertAction(title: "No", style: .default)
            
            setAddressAlert.addAction(yes)
            setAddressAlert.addAction(no)
            present(setAddressAlert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let cell = tableView.cellForRow(at: indexPath) as! AddressTableViewCell
            if cell.isDefault.isHidden {
                let setAddressAlert = UIAlertController(title: "Delete Address", message: "Do you want to delete this address?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
                    self.addressesList?.remove(at: indexPath.row)
                    self.viewModel.deleteAddress(indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.endUpdates()
                }
                let no = UIAlertAction(title: "No", style: .cancel)
                
                setAddressAlert.addAction(yes)
                setAddressAlert.addAction(no)
                present(setAddressAlert, animated: true)
            } else {
                let defaultAddressAlert = UIAlertController(title: "Invalid Operation", message: "Cannot delete the primary address", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel)
                defaultAddressAlert.addAction(ok)
                present(defaultAddressAlert, animated: true)
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func addNewAddressButton(_ sender: Any) {
        let addNew = self.storyboard?.instantiateViewController(withIdentifier: "addNew") as! AddNewAddressViewController
//MARK: -todo: pass current customer id -- (Done..ish)
        addNew.customerId = viewModel.customerID
        present(addNew, animated: true)
    }
   
    
@IBAction func unwindToAddresses(unwingSegue: UIStoryboardSegue){}


}
// MARK: - Extention to UITableView
// a help from the internet

// reference: https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
        }
        func restore() {
            self.backgroundView = nil
            self.separatorStyle = .none
        }
}
