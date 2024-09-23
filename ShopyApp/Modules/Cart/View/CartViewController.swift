//
//  CartViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var cartItems: UITableView!
    
    @IBOutlet weak var subtotal: UILabel!
    
    @IBOutlet weak var currency: UILabel!
    
    @IBOutlet weak var proceedButton: UIButton!
    
    
    @IBOutlet weak var nonRegisteredView: UIView!
    var viewModel = CartViewModel()
    
    var cartProducts: [LineItem]?
    
    var cartDidChange: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartItems.delegate = self
        cartItems.dataSource = self
        cartItems.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")

        proceedButton.isEnabled = false
        if !viewModel.isLoggedIn(){
            nonRegisteredView.isHidden = false
        }
        currency.text = UserDefaults.standard.string(forKey: "currencyTitle")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.isLoggedIn(){
            viewModel.checkNetworkReachability{ isReachable in
                if isReachable {
                    self.viewModel.loadData()
                    self.viewModel.bindResultToViewController = {
                        self.cartProducts = self.viewModel.getFilteredCart()
                        if (self.cartProducts?.count)! > 0 {
                            self.proceedButton.isEnabled = true
                        }
                        self.cartItems.reloadData()
                      //  self.calculateSubtotal()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
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
//        if cartProducts?.count == 0{
//            tableView.setEmptyView(title: "No products here yet", message: "Go ahead an add some products!")
//        }
//        else {
//            tableView.restore()
//        }
        return cartProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTableViewCell
        cell.productImage.kf.setImage(with: URL(string: (cartProducts?[indexPath.row].properties[0].value)!))
        cell.productTitle.text = String((cartProducts?[indexPath.row].name?.split(separator: "| ",maxSplits: 1)[1])!)
        cell.price.text = "\(UserDefaults.standard.string(forKey: "currencyTitle") ?? "") \(String(format: "%.2f",(UserDefaults.standard.double(forKey: "factor") * Double(cartProducts?[indexPath.row].price ?? "0.0")!)))"
        cell.availableQuantity.text = (cartProducts?[indexPath.row].properties[1].value)!
        cell.orderQuantity.text = String((cartProducts?[indexPath.row].quantity)!)
        if (cartProducts?[indexPath.row].quantity)! == 1{
            cell.decreaseButton.isEnabled = false
            cell.decreaseButton.alpha = 0.25
        }
        if Int(cell.orderQuantity.text!)! == Int(cell.availableQuantity.text!)! {
            cell.increaseButton.isEnabled = false
            cell.increaseButton.alpha = 0.25
        }
        cell.increaseButton.addTarget(self, action: #selector(increaseAction), for: .touchUpInside)
        cell.decreaseButton.addTarget(self, action: #selector(decreaseAction), for: .touchUpInside)
//MARK: Todo: Func. of deleteButton -- Done
        cell.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
// MARK: Todo: Edit deletion functionality api
            deleteAlert(tableView, indexPath: indexPath)
        }
    }
    
    @objc func deleteAction(_ sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: cartItems)
        guard let indexPath = cartItems.indexPathForRow(at: point) else {return}
        deleteAlert(cartItems, indexPath: indexPath)
    }
    @objc func increaseAction(_ sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: cartItems)
        guard let indexPath = cartItems.indexPathForRow(at: point) else {return}
        cartProducts?[indexPath.row].quantity += 1
        cartDidChange = true
      //  calculateSubtotal()
    }
    @objc func decreaseAction(_ sender: UIButton){
        let point = sender.convert(CGPoint.zero, to: cartItems)
        guard let indexPath = cartItems.indexPathForRow(at: point) else {return}
        cartProducts?[indexPath.row].quantity -= 1
        cartDidChange = true
      //  calculateSubtotal()
    }
    
    func deleteAlert(_ tableView: UITableView, indexPath: IndexPath){
        let alert = UIAlertController(title: "Confirm Delete", message: "Do you want to delete this product from cart?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
            self.cartProducts?.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            self.cartDidChange = true
            if (self.cartProducts?.count)! == 0 {
                self.proceedButton.isEnabled = false
            }
          //  self.calculateSubtotal()
        }
        let no = UIAlertAction(title: "No", style: .cancel)
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true)
    }
    
//    func calculateSubtotal(){
//        var totalPrice = 0.0
//        for product in cartProducts ?? []{
//            totalPrice += (UserDefaults.standard.double(forKey: "factor") * (Double(product.price) ?? 0.0)) * Double(product.quantity)
//        }
//        self.subtotal.text = String(format: "%.2f",totalPrice)
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        if segue.identifier == "reviewOrder"{
//            let orderReview = segue.destination as! OrderReviewViewController
////            orderReview.cartItems = cartProducts
//            orderReview.draftId = viewModel?.dummyDraftId
//        }
//        // Pass the selected object to the new view controller.
//    }
//    
    @IBAction func purchaseButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        if cartDidChange{
            print("Cart Items changed. Updating...")
            viewModel.updateOrder(cartItems: cartProducts)
        }
        dismiss(animated: true)
    }
   
}
