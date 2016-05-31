//
//  CustomLoginManageFlightTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/27/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class CustomLoginManageFlightTableViewCell: UITableViewCell {

    @IBOutlet weak var pnrNumber: UILabel!
    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var flightDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
