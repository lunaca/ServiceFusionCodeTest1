//
//  FavoriteCollectionViewCell.swift
//  peeps
//
//  Created by LUNVCA on 9/27/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet var image : UIImageView!
    @IBOutlet var name : UILabel!
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor.gray : UIColor.black
            self.image.alpha = isSelected ? 0.75 : 1.0
        }
        
}
 
}
