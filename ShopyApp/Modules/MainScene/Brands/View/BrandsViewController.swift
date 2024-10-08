//
//  BrandsViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 15/09/2024.
//

import UIKit
import Kingfisher
class BrandsViewController: UIViewController {
    @IBOutlet weak var itemsCollection: UICollectionView!
    @IBOutlet weak var itemsCount: UILabel!
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel = BrandsViewModel()
    var indicator : UIActivityIndicatorView?
    var result : Products?
    var sortedProducts : [Product]?
    var vendor : String?
    var brandImage : String?
    var flag = false
    var searchWord : String = ""
    var searching : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFlowLayout()
        registerCell()
        viewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                self.loadData2()
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }
       
    }
    
    @IBAction func sortList(_ sender: Any) {
        viewModel.sortByPrice()
        flag = !flag
        itemsCollection.reloadData()
    }
//    
//    func setupFlowLayout(){
//        let flowLayout = UICollectionViewFlowLayout()
//        let itemWidth = itemsCollection.frame.width / 2 - 14
//        flowLayout.itemSize = CGSize(width: itemWidth, height: (itemsCollection.frame.height/2)-16)
//        itemsCollection.collectionViewLayout = flowLayout
//        
//    }

}

// MARK: - UISetup

extension BrandsViewController{
    func IntializeProperties(){
        flag = false
        viewModel.result = Products(products: [])
        searchWord = ""
        searching = false
    }
    func registerCell(){
        itemsCollection.register(UINib(nibName: "ItemsCell", bundle: .main), forCellWithReuseIdentifier: "itemsCell")
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.itemsCollection.center
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


// MARK: - getData

extension BrandsViewController{

    func loadData2(){
        viewModel.loadData()
        viewModel.bindResultToViewController = {[weak self] in
            self?.indicator?.stopAnimating()
            self?.display()
            self?.itemsCollection.reloadData()
            self?.brandLogo.kf.setImage(with:URL(string: self?.brandImage ?? "placeHolder") ,placeholder: UIImage(named: "placeHolder"))
            self?.itemsCount.text =  "\(self?.viewModel.filteredResult?.count ?? 0) Items"
        }
    }

    
    func display() {
        viewModel.getAllData(vendor: vendor ?? " ")
        if (viewModel.filteredResult?.count  == 0) {
            itemsCollection.setEmptyMessage("No Items In Stock ")
        } else {
            itemsCollection.restore()
        }
        
    }
    
}


// MARK: - collectionView:

//
extension BrandsViewController :  UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate ,UICollectionViewDelegateFlowLayout{

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return viewModel.filteredResult?.count ?? 0
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = itemsCollection.dequeueReusableCell(withReuseIdentifier: "itemsCell", for: indexPath) as! ItemsCell
   
    let url = URL(string:viewModel.filteredResult?[indexPath.row].image.src ?? "placeHolder")
    cell.productImage.kf.setImage(with:url ,placeholder: UIImage(named: "placeHolder"))
    cell.productTitle.text = (viewModel.filteredResult?[indexPath.row].title ?? "").split(separator: "|").dropFirst().first.map(String.init)
    cell.productSubtitle.text = viewModel.filteredResult?[indexPath.row].vendor
    let price = Double(viewModel.filteredResult?[indexPath.row].variants.first?.price ?? "0.0")
    cell.productPrice.text = "\(price ?? 0.0)"
   
    return cell
}
func setupFlowLayout(){
    let flowLayout = UICollectionViewFlowLayout()
    let itemWidth = itemsCollection.frame.width / 2 - 15
    flowLayout.itemSize = CGSize(width: itemWidth, height: (itemsCollection.frame.height/2)-20)
    itemsCollection.collectionViewLayout = flowLayout
    
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
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "ProductInfo", bundle: nil)
    let productInfovc = storyboard.instantiateViewController(withIdentifier: "prodInfo") as! ProductInfoViewController
   
    productInfovc.productId = viewModel.filteredResult?[indexPath.row].id
   print(productInfovc.productId ?? 0)
    self.present(productInfovc, animated: true)
}


}
// MARK: - Empty Collection View Handling

extension UICollectionView {
    
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
    
    func restore() {
        self.backgroundView = nil
    }
}
