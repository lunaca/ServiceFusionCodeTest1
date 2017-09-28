//
//  AllTableViewCell.swift
//  peeps
//
//  Created by LUNVCA on 9/26/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit

class AllTableViewCell: UITableViewCell {
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
