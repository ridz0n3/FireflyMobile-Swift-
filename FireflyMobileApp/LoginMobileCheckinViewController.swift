//
//  LoginMobileCheckinViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/1/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginMobileCheckinViewController: CommonListViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let bookingList = listBooking[indexPath.row] as! NSDictionary
        showLoading() 
        
        FireFlyProvider.request(.CheckIn(signature, bookingList["pnr"] as! String, userId, bookingList["departure_station_code"] as! String, bookingList["arrival_station_code"] as! String)) { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if  json["status"].string == "success"{
                        let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                        let checkInDetailVC = storyboard.instantiateViewControllerWithIdentifier("MobileCheckInDetailVC") as! MobileCheckInDetailViewController
                        checkInDetailVC.checkInDetail = json.object as! NSDictionary as! [String : AnyObject]
                        checkInDetailVC.pnr = bookingList["pnr"] as! String
                        self.navigationController!.pushViewController(checkInDetailVC, animated: true)
                        
                    }else{
                        
                                showErrorMessage(json["message"].string!)
                    }
                    hideLoading()
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
