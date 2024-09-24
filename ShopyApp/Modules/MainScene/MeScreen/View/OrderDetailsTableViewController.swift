//
//  OrderDetailsTableViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 16/09/2024.
//

import UIKit

class OrderDetailsTableViewController: UITableViewController {
    var result : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil),forCellReuseIdentifier: "orderCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return result?.lineItems.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        cell.orderNum.text = result?.lineItems[indexPath.row].name?.split(separator: "|").dropFirst().first.map(String.init)
        cell.QuantityLabel.text = "Quantity"
        cell.CreatedDate.text = String(result?.lineItems[indexPath.row].quantity ?? 0 )
        cell.totalAmountLabel.text = "Price"
        cell.totalAmount.text = "\(result?.lineItems[indexPath.row].price ?? "") \(result?.currency ?? "")"
    
    return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "All Items"
    }

}
