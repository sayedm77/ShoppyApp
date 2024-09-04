//
//  HomeViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 04/09/2024.
//

import UIKit

class HomeViewController: UIViewController  ,UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var indicator : UIActivityIndicatorView?

    @IBOutlet weak var brandsCollection: UICollectionView!
    @IBOutlet weak var adsCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
         
     //   setIndicator()
    }
    override func viewWillAppear(_ animated: Bool) {
        registerCells()
        setupCollectionView()
      
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adsCollection{
            let cell = adsCollection.dequeueReusableCell(withReuseIdentifier: "AdCell", for: indexPath) as! AdsCell
           
            return cell
        } else{
            let cell = brandsCollection.dequeueReusableCell(withReuseIdentifier: "BrandsCell", for: indexPath) as! BrandsCell
         
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
