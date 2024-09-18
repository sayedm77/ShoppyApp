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
    var wishlistViewModel : WishlistViewModel?
    var loggedIn : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
       
        wishlistViewModel = WishlistViewModel()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = wishColletionView.frame.width / 2 - 10
        return CGSize(width: width, height: collectionView.frame.width-60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    
}
// MARK: - UI setUp
extension WishListViewController{
     func IntializeProperties(){
     wishListResult = []
     loggedIn = wishlistViewModel?.isLoggedIn()
        
     }
    func configureTableView(){
        wishColletionView.dataSource = self
        wishColletionView.delegate = self
        wishColletionView.register(UINib(nibName: "ItemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "wish")
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
extension WishListViewController: UIGestureRecognizerDelegate{
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
            self.wishlistViewModel?.updateWishList(wishList: self.wishListResult)
            Thread.sleep(forTimeInterval:0.5)
            self.viewWillAppear(true)
        }
        let no = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(no)
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
