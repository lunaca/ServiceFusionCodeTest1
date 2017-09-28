//
//  TFTableViewCell.swift
//  peeps
//
//  Created by LUNVCA on 9/26/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit

class TFTableViewCell: UITableViewCell {
    @IBOutlet var minus : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        minus.layer.cornerRadius = 12.0
        minus.clipsToBounds = true 
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
