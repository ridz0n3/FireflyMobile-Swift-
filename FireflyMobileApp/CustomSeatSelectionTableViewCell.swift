//
//  CustomSeatSelectionTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/21/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class CustomSeatSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var rowView: UIView!
    @IBOutlet weak var colABtn: UIButton!
    @IBOutlet weak var colAView: UIView!
    @IBOutlet weak var colDBtn: UIButton!
    @IBOutlet weak var colCView: UIView!
    @IBOutlet weak var colCBtn: UIButton!
    @IBOutlet weak var colFBtn: UIButton!
    @IBOutlet weak var colFView: UIView!
    @IBOutlet weak var colDView: UIView!
    
    @IBOutlet weak var removeSeat: UIButton!
    @IBOutlet weak var seatNumber: UILabel!
    @IBOutlet weak var passengerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
