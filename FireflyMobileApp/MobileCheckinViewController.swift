//
//  MobileCheckinViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/1/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLForm

class MobileCheckinViewController: CommonSearchDetailViewController {
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate{
            
            let pnr = self.formValues()[Tags.ValidationConfirmationNumber] as! String
            let departure_station_code = getStationCode(self.formValues()[Tags.ValidationDeparting] as! String, locArr: location, direction : "Departing")
            //self.formValues()[Tags.ValidationDeparting] as! String
            let arrival_station_code = getStationCode(self.formValues()[Tags.ValidationArriving] as! String, locArr: travel, direction : "Arriving")
            showHud("open")
            FireFlyProvider.request(.CheckIn("", pnr, "", departure_station_code, arrival_station_code), completion: { (result) -> () in
                showHud("close")
                switch result {
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if  json["status"].string == "success"{
                            let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                            let checkInDetailVC = storyboard.instantiateViewControllerWithIdentifier("MobileCheckInDetailVC") as! MobileCheckInDetailViewController
                            checkInDetailVC.checkInDetail = json.object as! NSDictionary
                            checkInDetailVC.pnr = pnr
                            self.navigationController!.pushViewController(checkInDetailVC, animated: true)
                        }else{
                            //showToastMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    
                case .Failure(let failureResult):
                    print (failureResult)
                }
                
            })
            
        }
        
    }

}
