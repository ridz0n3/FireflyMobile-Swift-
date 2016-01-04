//
//  CustomPaymentSummaryTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/23/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class CustomPaymentSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var wayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var flightNumberLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var flightDestination: UILabel!
    @IBOutlet weak var guestLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var guestPriceLbl: UILabel!
    @IBOutlet weak var taxesPrice: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    
    @IBOutlet weak var totalPriceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
