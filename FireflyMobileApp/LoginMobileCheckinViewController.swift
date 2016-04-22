//
//  LoginMobileCheckinViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/1/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import Realm

class LoginMobileCheckinViewController: CommonListViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.loginMobileCheckInScreen)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginMobileCheckinViewController.refreshCheckInList(_:)), name: "reloadCheckInList", object: nil)
        
        loadCheckInList()
    }

    func loadCheckInList(){
        
        let userInfo = defaults.objectForKey("userInfo") as! [String : String]
        var userData : Results<UserList>! = nil
        userData = realm.objects(UserList)
        mainUser = userData.filter("userId == %@", userInfo["username"]!)
        
        if mainUser.count != 0{
            checkInList = mainUser[0].checkinList.sorted("departureDateTime", ascending: false)
        }
        
    }
    
    func refreshCheckInList(notif : NSNotification){
        
        signature = mainUser[0].signature
        
        loadCheckInList()
        LoginMobileCheckinTableView.reloadData()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let bookingList = checkInList[indexPath.row]//listBooking[indexPath.row] as! NSDictionary
        showLoading() 
        
        FireFlyProvider.request(.CheckIn(signature, bookingList.pnr, userId, bookingList.departureStationCode, bookingList.arrivalStationCode)) { (result) -> () in
            
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
