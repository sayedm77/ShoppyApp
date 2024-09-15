//
//  AdsCell.swift
//  ShopyApp
//
//  Created by sayed mansour on 04/09/2024.
//

import UIKit

class AdsCell: UICollectionViewCell {
    
    @IBOutlet weak var adsImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adsImg.contentMode = .scaleAspectFit // or .scaleAspectFill depending on your needs
        adsImg.clipsToBounds = true

    }
}
