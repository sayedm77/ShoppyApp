//
//  PaymentViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 23/09/2024.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet weak var methods: UITableView!
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    var viewModel = PaymentViewModel()
    
    var draftId : Int!
    
    private var paymentRequest : PKPaymentRequest = PKPaymentRequest()
    
    var isApplePay: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        methods.delegate = self
        methods.dataSource = self
        methods.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "paymentCell")
        purchaseButton.isEnabled = false
        viewModel.loadData(draftId: draftId)
        viewModel.configurePaymentRequest(request: paymentRequest)

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Payment Method"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.paymentMethods.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell") as! PaymentTableViewCell
        cell.paymentImage.image = UIImage(named: (viewModel.paymentMethods[indexPath.row]))
        cell.paymentTitle.text = (viewModel.paymentMethods[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PaymentTableViewCell
        cell.selectedState.isHidden = false
        self.purchaseButton.isEnabled = true
        if indexPath.row == 0 {
            isApplePay = true
        } else {
            isApplePay = false
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PaymentTableViewCell
        cell.selectedState.isHidden = true
    }
    
    func tapForPay(){
        let amount = String(viewModel.getOrderTotalPrice())
            paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Cart Order", amount: NSDecimalNumber(string: amount))]
            
            let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            if controller != nil {
                controller!.delegate = self
                present(controller!, animated: true, completion: nil)
            }
    }
    
    func purchaseOrder(){
        viewModel.postOrder()
        viewModel.completeOrder(draftId: draftId)
        performSegue(withIdentifier: "orderConfirmed", sender: nil)
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func purchase(_ sender: Any) {
// MARK: TODO: make sure that the payment is done(case apple pay)
                if isApplePay {tapForPay()}
                else{
                    purchaseOrder()
                }
            }
}
  

extension PaymentViewController : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        self.purchaseOrder()
    }
}
