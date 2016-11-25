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
 
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.loginMobileCheckInScreen)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginMobileCheckinViewController.refreshCheckInList(_:)), name: NSNotification.Name(rawValue: "reloadCheckInList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginMobileCheckinViewController.emptyCheckInList(_:)), name: NSNotification.Name(rawValue: "emptyCheckInList"), object: nil)
        loadingIndicator.isHidden = indicator
        loadCheckInList()
    }

    func loadCheckInList(){
        
        let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
        var userData : Results<UserList>! = nil
        userData = realm.objects(UserList.self)
        mainUser = userData.filter("userId == %@", userInfo["username"]! as! String)
        
        if mainUser.count != 0{
            checkInList = mainUser[0].checkinList.sorted(byProperty: "departureDateTime", ascending: true)
        }
        
    }
    
    func emptyCheckInList(_ notif : NSNotification){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func refreshCheckInList(_ notif : NSNotification){
        
        signature = mainUser[0].signature
        loadingIndicator.isHidden = true
        loadCheckInList()
        LoginMobileCheckinTableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bookingList = checkInList[indexPath.row]//listBooking[indexPath.row] as! NSDictionary
        showLoading() 
        
        FireFlyProvider.request(.CheckIn(signature, bookingList.pnr, userId, bookingList.departureStationCode, bookingList.arrivalStationCode)) { (result) -> () in
            
            switch result {
                
            case .success(let successResult):
                do {
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if  json["status"].string == "success"{
                        let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                        let checkInDetailVC = storyboard.instantiateViewController(withIdentifier: "MobileCheckInDetailVC") as! MobileCheckInDetailViewController
                        checkInDetailVC.checkInDetail = json.object as! NSDictionary as! [String : AnyObject]
                        checkInDetailVC.pnr = bookingList["pnr"] as! String
                        self.navigationController!.pushViewController(checkInDetailVC, animated: true)
                        
                    }else{
                        showErrorMessage(json["message"].string!)
                    }
                    hideLoading()
                }
                catch {
                    hideLoading()
                    showErrorMessage("We are unable to locate the itinerary. Please verify the information is correct and try again.")
                }
                
            case .failure(let failureResult):
                hideLoading()
                showErrorMessage(failureResult.localizedDescription)
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
