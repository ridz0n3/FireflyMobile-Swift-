//
//  CustomPaymentSummaryTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/23/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class CustomPaymentSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var goingView: UIView!
    @IBOutlet weak var goingLbl: UILabel!
    @IBOutlet weak var goingDateLbl: UILabel!
    @IBOutlet weak var goingDestinationLbl: UILabel!
    @IBOutlet weak var goingFlightNumberLbl: UILabel!
    @IBOutlet weak var goingTimeLbl: UILabel!
    
    @IBOutlet weak var returnView: UIView!
    @IBOutlet weak var returnLbl: UILabel!
    @IBOutlet weak var returnDateLbl: UILabel!
    @IBOutlet weak var returnDestinationLbl: UILabel!
    @IBOutlet weak var returnFlightNumberLbl: UILabel!
    @IBOutlet weak var returnTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
