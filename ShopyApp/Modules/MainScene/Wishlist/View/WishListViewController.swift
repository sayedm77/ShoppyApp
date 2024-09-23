//
//  WishListViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 17/09/2024.
//

import UIKit
import Kingfisher

class WishListViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    @IBOutlet weak var notLoggedInView: UIView!
    @IBOutlet weak var wishColletionView: UICollectionView!
    
    var wishListResult : [LineItem]?
    var indicator : UIActivityIndicatorView?
    var wishlistViewModel = WishlistViewModel()
    var loggedIn : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupFlowLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        IntializeProperties()
        setupLongGestureRecognizerOnCollection()
        //print(loggedIn)
        wishlistViewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                if self.loggedIn == true{
                    self.notLoggedInView.isHidden = true
                    self.setIndicator()
                    self.loadWishlistData()
                }else{
                    self.notLoggedInView.isHidden = false
                }
                
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductInfoSegue"{
            if let indexPath = sender as? IndexPath {
                let destinationVC = segue.destination as? ProductInfoViewController
                destinationVC?.productId = wishListResult?[indexPath.row].productID
                
            }
        }
    }
    
    
    // MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishListResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wish", for: indexPath) as! ItemsCell
        let factor = UserDefaults.standard.value(forKey: "factor")as! Double
        cell.productImage.kf.setImage(with:URL(string: (wishListResult?[indexPath.row].properties[0].value) ?? "") ,placeholder: UIImage(named: "placeHolder"))
        cell.productTitle.text = wishListResult?[indexPath.row].name
        cell.productSubtitle.text = " "
        let price = Double(wishListResult?[indexPath.row].price ?? "0.0")
        cell.productPrice.text = String(format: "%.2f" ,factor * (price ?? 0.0))
        
        cell.currency.text = UserDefaults.standard.string(forKey: "currencyTitle")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProductInfoSegue", sender: indexPath)
    }
    
    func setupFlowLayout(){
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = wishColletionView.frame.width / 2 - 15
        flowLayout.itemSize = CGSize(width: itemWidth, height: (wishColletionView.frame.height/2)-20)
        wishColletionView.collectionViewLayout = flowLayout
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 9.0, bottom: 12.0, right: 9.0)
    }
    
}
// MARK: - UI setUp
extension WishListViewController{
     func IntializeProperties(){
     wishListResult = []
     loggedIn = wishlistViewModel.isLoggedIn()
        
     }
    func configureTableView(){
        wishColletionView.dataSource = self
        wishColletionView.delegate = self
        wishColletionView.register(UINib(nibName: "ItemsCell", bundle: nil), forCellWithReuseIdentifier: "wish")
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.wishColletionView.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
extension WishListViewController {

 func loadWishlistData(){
     wishlistViewModel.loadWishlistData()
     wishlistViewModel.bindWishlistToViewController = {[weak self] in
         DispatchQueue.main.async {
             self?.displayWishlist()
             self?.wishColletionView.reloadData()
             
         }
         
     }
 }
    func displayWishlist() {
        indicator?.stopAnimating()
        wishListResult = wishlistViewModel.getFilteredItems(items: wishlistViewModel.getWishlistData())
        if (wishListResult?.isEmpty ?? false) {
            wishColletionView.setEmptyMessage("No items in Wish list ")
        } else {
            wishColletionView.restore()
        }
        
    }
    
}
extension WishListViewController: UIGestureRecognizerDelegate {
    func setupLongGestureRecognizerOnCollection() {
       let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
       longPressedGesture.minimumPressDuration = 0.5
       longPressedGesture.delegate = self
       longPressedGesture.delaysTouchesBegan = true
       wishColletionView?.addGestureRecognizer(longPressedGesture)
      }
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
         return
        }

        let p = gestureRecognizer.location(in:wishColletionView)

        if let indexPath = wishColletionView?.indexPathForItem(at: p) {
         print("Long press at item: \(indexPath.row)")
            showDeleteAlert(index: indexPath)
        }
       }
    func showDeleteAlert(index: IndexPath){
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you Want to delete item from Wishlist", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Delete", style: .default) { _ in
            self.wishListResult?.remove(at: index.row)
            self.wishlistViewModel.updateWishList(wishList: self.wishListResult)
            Thread.sleep(forTimeInterval:0.5)
            self.viewWillAppear(true)
        }
        let no = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(no)
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
