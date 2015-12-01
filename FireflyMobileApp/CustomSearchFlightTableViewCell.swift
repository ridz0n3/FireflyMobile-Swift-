//
//  CustomSearchFlightTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class CustomSearchFlightTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var airportLbl: UILabel!
    @IBOutlet weak var lineStyle: UIImageView!
    
    @IBOutlet weak var adultCount: UILabel!
    @IBOutlet weak var infantCount: UILabel!
    
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var oneWayBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func plus(sender: AnyObject) {
        let plus : UIButton = sender as! UIButton
        
        if plus.tag == 2 {
            var count: Int? = Int(self.adultCount.text!)
            count = count! + 1
            self.adultCount.text = String(format: "%i", count!)
            
        }else if plus.tag == 6 {
            var count: Int? = Int(self.infantCount.text!)
            count = count! + 1
            self.infantCount.text = String(format: "%i", count!)
        }

    }
    
    @IBAction func minus(sender: AnyObject) {
        let minus : UIButton = sender as! UIButton
        
        if (minus.tag == 1) {
            var count: Int? = Int(self.adultCount.text!)
            if count != 0 {
                count = count! - 1;
            }
            self.adultCount.text = String(format : "%i",count!)
            
        }else if (minus.tag == 5) {
            var count: Int? = Int(self.infantCount.text!)
            if count != 0 {
                count = count! - 1;
            }
            self.infantCount.text = String(format : "%i",count!)
        }
    }
}
