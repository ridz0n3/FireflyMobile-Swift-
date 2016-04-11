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
    @IBOutlet weak var operatedMH: UILabel!
    
    @IBOutlet weak var flightDestination: UILabel!
    @IBOutlet weak var guestLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var guestPriceLbl: UILabel!
    @IBOutlet weak var taxesPrice: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var infantPriceLbl: UILabel!
    @IBOutlet weak var infantLbl: UILabel!
    
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    @IBOutlet weak var confirmationLbl: UILabel!
    @IBOutlet weak var reservationLbl: UILabel!
    @IBOutlet weak var bookDateLbl: UILabel!
    
    @IBOutlet weak var confNumberLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    
    @IBOutlet weak var contactNameLbl: UILabel!
    @IBOutlet weak var contactCountryLbl: UILabel!
    @IBOutlet weak var contactMobileLbl: UILabel!
    @IBOutlet weak var contactAlternateLbl: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    
    @IBOutlet weak var passengerNameLbl: UILabel!
    
    @IBOutlet weak var totalPaidLbl: UILabel!
    @IBOutlet weak var totalDueLbl: UILabel!
    @IBOutlet weak var paymentTotalPriceLbl: UILabel!
    
    @IBOutlet weak var cardTypeLbl: UILabel!
    @IBOutlet weak var cardPayLbl: UILabel!
    @IBOutlet weak var cardStatusLbl: UILabel!
    
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var servicePriceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
