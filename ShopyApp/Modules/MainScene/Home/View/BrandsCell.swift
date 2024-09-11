//
//  BrandsCell.swift
//  ShopyApp
//
//  Created by sayed mansour on 04/09/2024.
//

import UIKit

class BrandsCell: UICollectionViewCell {

    @IBOutlet weak var brandImg: UIImageView!
    @IBOutlet weak var vBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        vBackground.layer.borderWidth = 2
        vBackground.layer.borderColor = UIColor.black.cgColor
        vBackground.layer.masksToBounds = false
        vBackground.layer.cornerRadius = (vBackground.frame.height)/12
        vBackground.clipsToBounds = true
    }

}
