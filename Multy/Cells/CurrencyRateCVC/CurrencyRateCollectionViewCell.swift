//
//  CurrencyRateCollectionViewCell.swift
//  Multy
//
//  Created by Artyom Alekseev on 14.06.2018.
//  Copyright © 2018 Idealnaya rabota. All rights reserved.
//

import UIKit

class CurrencyRateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var holderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func fill(symbol: String, rate: String, icon: UIImage, selected: Bool) {
        symbolLabel.text = symbol
        rateLabel.text = rate
        iconImageView.image = icon
        holderView.layer.borderWidth = selected ? 3 : 0
        holderView.layer.borderColor = selected ? #colorLiteral(red: 0.4549019608, green: 0.7254901961, blue: 1, alpha: 1).cgColor : UIColor.clear.cgColor
    }
}
