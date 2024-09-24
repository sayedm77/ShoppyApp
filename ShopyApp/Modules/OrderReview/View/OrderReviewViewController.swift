//
//  OrderReviewViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import UIKit
import Kingfisher

class OrderReviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var itemsCollection: UICollectionView!
    
    @IBOutlet weak var subTotal: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var discountField: UITextField!
    
    @IBOutlet weak var applyDiscountButton: UIButton!
    
    var cartItems: [LineItem]?
    
    var draftId: Int!
    
    var viewModel = OrderReviewViewModel()
    
    var discountValue = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCollection.delegate = self
        itemsCollection.dataSource = self
        itemsCollection.register(UINib(nibName: "ItemsCell", bundle: .main), forCellWithReuseIdentifier: "itemCell")
     
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                self.reloadView()
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection😞", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reloadView(){
        Thread.sleep(forTimeInterval: 0.35)
        viewModel.loadData(draftId: draftId)
        viewModel.bindResultToViewController = {
            self.cartItems = self.viewModel.getFilteredCart()
            self.itemsCollection.reloadData()
            self.calculateLabels()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cartItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCollection.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemsCell
        cell.productTitle.text = String(cartItems?[indexPath.row].name?.split(separator: "|")[1] ?? "")
        cell.productSubtitle.text = "Quantity: \(String((cartItems?[indexPath.row].quantity) ?? 1))"
        cell.currency.text = UserDefaults.standard.string(forKey: "currencyTitle")
        cell.productImage.kf.setImage(with: URL(string: cartItems?[indexPath.row].properties[0].value ?? ""))
        cell.productPrice.text = "\(String(format: "%.2f",(UserDefaults.standard.double(forKey: "factor") * Double(cartItems?[indexPath.row].quantity ?? 1) * (Double(cartItems?[indexPath.row].price ?? "0.0") ?? 0.0))))"
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = itemsCollection.frame.width / 2 - 20
        return CGSize(width: width, height: (itemsCollection.frame.height)-60)
    }
    
    func calculateLabels(){
        var subtotalPrice = 0.0
        for product in cartItems ?? []{
            subtotalPrice += (UserDefaults.standard.double(forKey: "factor") * (Double(product.price) ?? 0.0)) * Double(product.quantity)
        }
        self.subTotal.text = "\(String(format: "%.2f",subtotalPrice)) \(UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD")"
        self.discount.text = "\("\(String(discountValue))") \(UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD")"
        self.totalPrice.text = "\(String(format: "%.2f",subtotalPrice + discountValue)) \(UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD")"
    }

    @IBAction func applyDiscount(_ sender: Any) {
        // MARK: - Todo: applying discount logic
                if applyDiscountButton.titleLabel?.text == "Apply"{
                    let amount = viewModel.check(discountCode: discountField.text ?? "")
                    print(amount)
                    if amount != 0.0 {
                        discountValue = amount
                        print(discountValue)
                        calculateLabels()
                    }
                    applyDiscountButton.setTitle("Change", for: .normal)
                    discountField.isUserInteractionEnabled = false
                    discountField.alpha = 0.5
                } else {
                    viewModel.clearRuleId()
                    discountValue = 0.0
                    calculateLabels()
                    applyDiscountButton.setTitle("Apply", for: .normal)
                    discountField.isUserInteractionEnabled = true
                    discountField.alpha = 1.0
                }
    }
    
  // MARK: - Navigation

      // In a storyboard-based application, you will often want to do a little preparation before navigation
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          // Get the new view controller using segue.destination.
          if segue.identifier == "proceed"{
              let addressBook = segue.destination as! AddressBookViewController
              addressBook.draftId = self.draftId
          }
          // Pass the selected object to the new view controller.
      }
    @IBAction func proceedToAddress(_ sender: Any) {
        viewModel.putDiscount(draftId: draftId)
        performSegue(withIdentifier: "proceed", sender: nil)
    }

}
