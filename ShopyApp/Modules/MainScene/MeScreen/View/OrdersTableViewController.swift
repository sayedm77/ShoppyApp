//
//  OrdersTableViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 16/09/2024.
//

import UIKit

class OrdersTableViewController: UITableViewController {
    var result : Orders?
    var indicator : UIActivityIndicatorView?
    var ordersViewModel : OrdersTableViewModel?
    var customerId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        ordersViewModel = OrdersTableViewModel()
        IntializeProperties()
        setIndicator()
        ordersViewModel?.checkNetworkReachability{ isReachable in
            if isReachable {
                self.loadData()
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return result?.orders.count ?? 0
    }
// back soon
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        cell.orderNum.text = "Order No\(result?.orders[indexPath.row].id ?? 0 )"
        cell.totalAmount.text = "\(result?.orders[indexPath.row].totalPrice ?? "") \(result?.orders[indexPath.row].currency ?? "")"
        cell.CreatedDate.text = result?.orders[indexPath.row].createdAt.split(separator: "T").first.map(String.init)
        return cell
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "All orders"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! OrderDetailsTableViewController
        vc.result = result?.orders[tableView.indexPathForSelectedRow!.row]
    }


}
extension OrdersTableViewController{
    func IntializeProperties(){
        result = Orders(orders: [])
        customerId = ordersViewModel?.getCustomerId()
    }
    func registerCell(){
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil),forCellReuseIdentifier: "orderCell")
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.tableView.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
extension OrdersTableViewController{
    func loadData(){
        ordersViewModel = OrdersTableViewModel()
        ordersViewModel?.loadData()
        ordersViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                
                self?.display()
                self?.tableView.reloadData()
            
            }
        }
    }
    func display() {
        indicator?.stopAnimating()
        result?.orders = ordersViewModel?.getAllData( customerId: customerId ?? 0) ?? []
     
        if (result?.orders.count  == 0) {
            tableView.setEmptyMessage("No Orders Yet ")
        } else {
            tableView.restor()
        }
        
    }
    
    
}
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restor() {
        self.backgroundView = nil
    }
}
