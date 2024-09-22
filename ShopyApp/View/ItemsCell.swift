//
//  ItemsCell.swift
//  ShopyApp
//
//  Created by sayed mansour on 07/09/2024.
//

import UIKit
import Kingfisher

class ItemsCell: UICollectionViewCell {
    @IBOutlet weak var vBackGround: UIView!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSubtitle: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add shadow
        vBackGround.layer.shadowColor = UIColor.black.cgColor
        vBackGround.layer.shadowOpacity = 0.5
        vBackGround.layer.shadowOffset = CGSize(width: 0, height: 2)
        vBackGround.layer.shadowRadius = 4
        vBackGround.layer.borderColor = UIColor.black.cgColor
        vBackGround.layer.borderWidth = 1
        vBackGround.layer.borderColor = UIColor.black.cgColor
        vBackGround.layer.masksToBounds = false
        vBackGround.layer.cornerRadius = (vBackGround.frame.height)/13
        vBackGround.clipsToBounds = true
        
    }
    func configureCell(product:Product?){
        guard let url = URL(string: product?.image.src ?? "") else{return}
        productImage.kf.setImage(with: url,placeholder:UIImage(named: "placeHolder"))
        productPrice.text = ExchangeCurrency.exchangeCurrency(amount: product?.variants.first?.price)
        productTitle.text = product?.title
        productSubtitle.text = product?.vendor
        currency.text =  ExchangeCurrency.getCurrency()
    }
}
