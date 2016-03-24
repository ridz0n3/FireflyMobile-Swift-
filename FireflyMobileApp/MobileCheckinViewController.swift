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
            
            let deptArr = (self.formValues()[Tags.ValidationDeparting] as! String).componentsSeparatedByString(" (")
            
            let arrivalArr = (self.formValues()[Tags.ValidationArriving] as! String).componentsSeparatedByString(" (")
            
            let pnr = self.formValues()[Tags.ValidationConfirmationNumber] as! String
            let departure_station_code = getStationCode(deptArr[0], locArr: location, direction : "Departing")
            //self.formValues()[Tags.ValidationDeparting] as! String
            let arrival_station_code = getStationCode(arrivalArr[0], locArr: travel, direction : "Arriving")
            showLoading(self) //showHud("open")
            FireFlyProvider.request(.CheckIn("", pnr, "", departure_station_code, arrival_station_code), completion: { (result) -> () in
                //showHud("close")
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
                            //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                        }
                        hideLoading(self)
                    }
                    catch {
                        showErrorMessage("We are unable to locate the itinerary. Please verify the information is correct and try again.")
                    }
                    
                case .Failure(let failureResult):
                    hideLoading(self)
                    showErrorMessage(failureResult.nsError.localizedDescription)
                }
                
            })
            
        }
        
    }

}
