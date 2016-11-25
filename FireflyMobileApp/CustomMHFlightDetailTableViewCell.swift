//
//  CustomMHFlightDetailTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/29/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox

class CustomMHFlightDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var arrivalTimeLbl: UILabel!
    @IBOutlet weak var arrivalAirportLbl: UILabel!
    @IBOutlet weak var flightIcon: UIImageView!
    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var departureAirportLbl: UILabel!
    
    @IBOutlet weak var economyPromoLbl: UILabel!
    @IBOutlet weak var economyLbl: UILabel!
    @IBOutlet weak var businessLbl: UILabel!
    @IBOutlet weak var economyPromoPriceLbl: UILabel!
    @IBOutlet weak var economyPriceLbl: UILabel!
    @IBOutlet weak var businessPriceLbl: UILabel!
    
    @IBOutlet weak var economyPromoCheckBox: M13Checkbox!
    @IBOutlet weak var economyCheckBox: M13Checkbox!
    @IBOutlet weak var businessCheckBox: M13Checkbox!
    
    @IBOutlet weak var economyPromoSoldView: UIView!
    @IBOutlet weak var economySoldView: UIView!
    @IBOutlet weak var businessSoldView: UIView!
    
    @IBOutlet weak var economyPromoBtn: UIButton!
    @IBOutlet weak var economyBtn: UIButton!
    @IBOutlet weak var businessBtn: UIButton!
    
    @IBOutlet weak var operateLbl: UILabel!
    @IBOutlet weak var economyPromoNotAvailableView: UIView!
    @IBOutlet weak var economyNotAvailableView: UIView!
    @IBOutlet weak var businessNotAvailableView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        economyPromoCheckBox.checkHeight = 30
        economyCheckBox.checkHeight = 30
        businessCheckBox.checkHeight = 30
        // Configure the view for the selected state
    }

}
