//
//  HomeViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 04/09/2024.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController  ,UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var indicator : UIActivityIndicatorView?
    var viewModel = HomeViewModel()
    @IBOutlet weak var brandsCollection: UICollectionView!
    @IBOutlet weak var adsCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       //  registerCells()
     //   setIndicator()
    }
    override func viewWillAppear(_ animated: Bool) {
        registerCells()
        setupCollectionView()
        loadData()
    }
    func registerCells (){
        adsCollection.register(UINib(nibName: "AdsCell", bundle: .main), forCellWithReuseIdentifier: "AdCell")
        brandsCollection.register(UINib(nibName: "BrandsCell", bundle: .main), forCellWithReuseIdentifier: "BrandsCell")
        
    }
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        brandsCollection.setCollectionViewLayout(layout, animated: true)
        
    }
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.brandsCollection.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
    }
    

        
        func displayBrands() {
          _  = viewModel.getBrandsData()
        }
        
        func displayAdsData() {
            indicator?.stopAnimating()
            _ = viewModel.getAdsData()
        }
        func loadData(){
           
           viewModel.loadBrandCollectionData()
           viewModel.bindBrandsResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    self?.displayBrands()
                    self?.brandsCollection.reloadData()
                    
                }
                
            }
            viewModel.loadAdsCollectionData()
            viewModel.bindAdsResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    self?.displayAdsData()
                    self?.adsCollection.reloadData()
                    
                }
            }
            
        }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == adsCollection{
            print("hello \(viewModel.Adsresult?.priceRules.count)")
            return viewModel.Adsresult?.priceRules.count ?? 0
        } else{
            return viewModel.Brandsresult?.smartCollections.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adsCollection{
            let cell = adsCollection.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdsCell
            cell.adsImg.image = UIImage(named: "Ad\(indexPath.row)")
            return cell
        } else{
            let cell = brandsCollection.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCell
            let url = URL(string:viewModel.Brandsresult?.smartCollections[indexPath.row].image.src ?? "placeHolder")
            cell.brandImg.kf.setImage(with:url ,placeholder: UIImage(named: "placeHolder"))
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == adsCollection{
            return CGSize(width: (UIScreen.main.bounds.width) - 50, height: (adsCollection.frame.height) - 50)
        } else{
            let widthPerItem = brandsCollection.frame.width / 2 - 20
            return CGSize(width:widthPerItem, height:(brandsCollection.frame.height/2.5)-20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 9.0, bottom: 10.0, right: 9.0)
    }
}
