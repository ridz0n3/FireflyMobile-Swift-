//
//  CustomChangeFlightTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class CustomChangeFlightTableViewCell: UITableViewCell {

    @IBOutlet weak var departureLbl: UILabel!
    @IBOutlet weak var arrivalLbl: UILabel!
    @IBOutlet weak var dateTxt: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
