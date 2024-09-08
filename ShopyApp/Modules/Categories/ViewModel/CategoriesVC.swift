//
//  CategoriesVC.swift
//  ShopyApp
//
//  Created by sayed mansour on 07/09/2024.
//

import UIKit

class CategoriesVC: UIViewController {
 var arri = ["ahmed", "mo"]
    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCollection.delegate = self
        itemCollection.dataSource = self
        setupFlowLayout()
        registerCell()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        registerCell()
    }

    func registerCell(){
        
        
        itemCollection.register(UINib(nibName: "ItemsCell", bundle: .main), forCellWithReuseIdentifier: "itemCell")
        
    }

}
extension CategoriesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollection.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemsCell
       
        return cell
    }
    func setupFlowLayout(){
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = itemCollection.frame.width / 2 - 15
        flowLayout.itemSize = CGSize(width: itemWidth, height: (itemCollection.frame.height/2)-20)
        itemCollection.collectionViewLayout = flowLayout
        
    }

//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let widthPerItem = (view.bounds.width - 20) / 2.5
//        return CGSize(width:widthPerItem, height:(itemCollection.frame.height/2.5)-20)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: itemCollection.frame.width / 2 - 10, height: (itemCollection.frame.height/2)-20) // Example size, adjust as needed
//    }
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
