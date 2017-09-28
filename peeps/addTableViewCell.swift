//
//  addTableViewCell.swift
//  peeps
//
//  Created by LUNVCA on 9/26/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit

class addTableViewCell: UITableViewCell {
    @IBOutlet var plus : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        plus.layer.cornerRadius = 12.0
        plus.clipsToBounds = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    }
