//
//  MobileTermTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/5/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox

class MobileTermTableViewCell: UITableViewCell {

    @IBOutlet weak var termCheck: M13Checkbox!
    @IBOutlet weak var termText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
