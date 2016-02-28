//
//  CustomFlightDetailTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox

class CustomFlightDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var arrivalTimeLbl: UILabel!
    @IBOutlet weak var arrivalAirportLbl: UILabel!
    @IBOutlet weak var flightIcon: UIImageView!
    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var departureAirportLbl: UILabel!
    @IBOutlet weak var checkFlight: M13Checkbox!

    @IBOutlet weak var economyPromoLbl: UILabel!
    @IBOutlet weak var economyLbl: UILabel!
    @IBOutlet weak var businessLbl: UILabel!
    @IBOutlet weak var economyPromoPriceLbl: UILabel!
    @IBOutlet weak var economyPriceLbl: UILabel!
    @IBOutlet weak var businessPriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
