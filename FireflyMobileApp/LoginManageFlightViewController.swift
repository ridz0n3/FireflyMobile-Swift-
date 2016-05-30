//
//  LoginManageFlightViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/27/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginManageFlightViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var loginManageFlightTableView: UITableView!
    
    var userId = String()
    var signature = String()
    var listBooking = NSArray()
    var groupBookingList = [String : AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.loginManageFlightScreen)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupBookingList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            
            if groupBookingList["Active"]?.count == 0{
                return 1
            }else{
                return (groupBookingList["Active"]?.count)!
            }
            
        }else{
            
            if groupBookingList["notActive"]?.count == 0{
                return 1
            }else{
                return (groupBookingList["notActive"]?.count)!
            }
            
        }
        //return listBooking.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            if groupBookingList["Active"]?.count == 0{
                let cell = loginManageFlightTableView.dequeueReusableCellWithIdentifier("NoUpcomingCell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
                
                return cell
            }else{
                let cell = loginManageFlightTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
                
                let bookingList = groupBookingList["Active"] as! [AnyObject]
                let bookingData = bookingList[indexPath.row]
                
                cell.flightNumber.text = "\(bookingData["pnr"]! as! String)"
                cell.flightDate.text = "\(bookingData["date"]! as! String)"
                
                return cell
            }
            
        }else{
            
            if groupBookingList["notActive"]?.count == 0{
                let cell = loginManageFlightTableView.dequeueReusableCellWithIdentifier("NoCompletedCell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
                return cell
            }else{
                let cell = loginManageFlightTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
                
                let bookingList = groupBookingList["notActive"] as! [AnyObject]
                let bookingData = bookingList[indexPath.row]
                
                cell.flightNumber.text = "\(bookingData["pnr"]! as! String)"
                cell.flightDate.text = "\(bookingData["date"]! as! String)"
                
                return cell
            }
            
            
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("PassengerHeader", owner: self, options: nil)[0] as! PassengerHeaderView
        
        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        //let index = UInt(section)
        var title = String()
        
        if section == 0{
            title = "Upcoming Trips"
        }else{
            title = "Completed Travels"
        }
        
        sectionView.sectionLbl.text = title
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if groupBookingList["Active"]?.count != 0 || groupBookingList["notActive"]?.count != 0{
            
            var bookingList = NSDictionary()
            
            if indexPath.section == 0{
                let bookingData = groupBookingList["Active"] as! [AnyObject]
                bookingList = bookingData[indexPath.row] as! NSDictionary
            }else{
                let bookingData = groupBookingList["notActive"] as! [AnyObject]
                bookingList = bookingData[indexPath.row] as! NSDictionary
            }
            
            //let bookingList = listBooking[indexPath.row] as! NSDictionary
            let userInfo = defaults.objectForKey("userInfo") as! [String:AnyObject]
            let username = userInfo["username"] as! String
            let customerNumber = userInfo["customer_number"] as! String
            
            defaults.setValue(username, forKey: "userName")
            defaults.setValue(userId, forKey: "userID")
            defaults.synchronize()
            
            showLoading()
            FireFlyProvider.request(.RetrieveBooking(signature, bookingList["pnr"] as! String,username, userId, customerNumber)) { (result) -> () in
                
                switch result {
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if json["status"] == "success"{
                            
                            defaults.setObject(json.object, forKey: "manageFlight")
                            defaults.synchronize()
                            
                            let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                            let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                            manageFlightVC.isLogin = true
                            self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            
                        }else if json["status"].string == "error"{
                            
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
