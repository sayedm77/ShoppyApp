//
//  CategoriesVC.swift
//  ShopyApp
//
//  Created by sayed mansour on 07/09/2024.
//

import UIKit
import Kingfisher
class CategoriesVC: UIViewController {
    
    var indicator : UIActivityIndicatorView?
    var viewModel = CategoriesViewModel()
    var category: String?
    var subCategory: String?
    
    
    
    @IBOutlet weak var subCategorySegment: UISegmentedControl!
    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCollection.delegate = self
        itemCollection.dataSource = self
        setupFlowLayout()
        setIndicator()
        registerCell()
        setupSegmentesControl()
        viewModel.checkNetworkReachability{ isReachable in
          
            if isReachable {
                self.loadData()
                self.categorySegment.selectedSegmentIndex = 0
                self.subCategorySegment.selectedSegmentIndex = 0
                
            } else {
                DispatchQueue.main.async {
                    self.showAlert()
                }
            }
        }

        
    }
    
}
    // MARK: - UISetUp
    
    extension CategoriesVC{
        func setIndicator(){
            indicator = UIActivityIndicatorView(style: .large)
            indicator?.color = .black
            indicator?.center = self.itemCollection.center
            indicator?.startAnimating()
            self.view.addSubview(indicator!)
            
        }
        func registerCell(){
            
            
            itemCollection.register(UINib(nibName: "ItemsCell", bundle: .main), forCellWithReuseIdentifier: "itemCell")
            
        }
        func setupSegmentesControl(){
            categorySegment.addTarget(self, action: #selector(segmentedControlCategoryChanged(_:)), for: .valueChanged)
            subCategorySegment.addTarget(self, action: #selector(segmentedControlSuCategoryChanged(_:)), for: .valueChanged)
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

extension CategoriesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.filteredResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollection.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemsCell
       
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
        let itemWidth = itemCollection.frame.width / 2 - 15
        flowLayout.itemSize = CGSize(width: itemWidth, height: (itemCollection.frame.height/2)-20)
        itemCollection.collectionViewLayout = flowLayout
        
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
// MARK: - getData

extension CategoriesVC {
    func loadData(){
        viewModel.loadData()
        viewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                
                self?.filterResults()
                
                
            }
        }
    }
    
    
    @objc func segmentedControlCategoryChanged(_ sender: UISegmentedControl) {
        
        category = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        filterResults(category: category ?? "All",subCategory: subCategory ?? "All")
    }
    @objc func segmentedControlSuCategoryChanged(_ sender: UISegmentedControl) {
        
        subCategory = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "All"
        filterResults(category: category ?? "All",subCategory: subCategory ?? "All")
    }

    func filterResults(category:String = "All",subCategory: String = "All"){
        indicator?.stopAnimating()
        
        if category == "Women"{
            viewModel.filteredResult = viewModel.getWomenData()
           
        }else if category == "Men"{
            viewModel.filteredResult = viewModel.getMenData()
            
        }else if category == "Kids"{
            viewModel.filteredResult = viewModel.getKidsData()
            
        }else if category == "All"{
            viewModel.filteredResult = viewModel.getAllData()
            
        }
        if subCategory != "All"{
            
            viewModel.filteredResult = viewModel.filteredResult?.filter{
                    $0.productType.rawValue == subCategory.uppercased()
                } ?? []
        }
       // checkIfNoItems()
        itemCollection.reloadData()
    }
    
//    func checkIfNoItems(){
//        if (viewModel.filteredResult?.count  == 0) {
//            itemCollection. setEmptyMessage("No Items In Stock ")
//        } else {
//            itemCollection.restore()
//        }
//    }
}
