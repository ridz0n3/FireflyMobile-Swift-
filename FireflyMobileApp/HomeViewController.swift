//
//  HomeViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var homeMenuTableView: UITableView!
    
    var menuTitle:[String] = ["","BOOK FLIGHT", "MANAGE FLIGHT", "MOBILE CHECK-IN", "BOARDING PASS",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "reloadHome", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            if self.view.frame.size.height < self.view.frame.size.width {
                return self.view.frame.size.width - 236
            }else{
                return self.view.frame.size.height - 236
            }
            
        }
        else if indexPath.row == 5 {
            
            return 36
            
        }else {
        
            return 50;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath) as! CustomHomeMenuTableViewCell
            
            if (defaults.objectForKey("banner") != nil){
                
                 let imageURL = defaults.objectForKey("banner") as! String
                Alamofire.request(.GET, imageURL).response(completionHandler: { (request, response, data, error) -> Void in
                    cell.banner.image = UIImage(data: data!)
                })
                
                
            }
            
            return cell
        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier("SocialCell", forIndexPath: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomHomeMenuTableViewCell
            
            let replaced = menuTitle[indexPath.row].stringByReplacingOccurrencesOfString(" ", withString: "")
            
            cell.bgView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
            cell.menuLbl?.text = menuTitle[indexPath.row]
            cell.menuIcon.image = UIImage(named: replaced)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 1{
            
            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
            let bookFlightVC = storyboard.instantiateViewControllerWithIdentifier("BookFlightVC") as! SearchFlightViewController
            self.navigationController!.pushViewController(bookFlightVC, animated: true)
            
        }else if indexPath.row == 2{
            /*let date = NSDate()
            let addtime = date.dateByAddingTimeInterval(1.0 * 60.0)
            
            let notification = UILocalNotification()
            if #available(iOS 8.2, *) {
                notification.alertTitle = "Firefly"
            } else {
                // Fallback on earlier versions
            }
            
            notification.userInfo = ["identifier" : "time out", "msg" : "Your flight will depart in 10minutes more, please hurry"]
            notification.alertBody = "Hurry"
            notification.fireDate = addtime
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)*/
            if try! LoginManager.sharedInstance.isLogin(){
                let userinfo = defaults.objectForKey("userInfo")
                showHud()
                
                FireFlyProvider.request(.RetrieveBookingList(userinfo!["username"] as! String, userinfo!["password"] as! String, "manage_booking"), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            self.hideHud()
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("LoginManageFlightVC") as! LoginManageFlightViewController
                                manageFlightVC.userId = "\(json["user_id"])"
                                manageFlightVC.signature = json["signature"].string!
                                manageFlightVC.listBooking = json["list_booking"].arrayObject!
                                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            }else{
                                self.showToastMessage(json["message"].string!)
                            }
                        }
                        catch {
                            
                        }
                        print (successResult.data)
                    case .Failure(let failureResult):
                        print (failureResult)
                    }
                })
                
            }else{
            
            let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
            let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightVC") as! ManageFlightViewController
            self.navigationController!.pushViewController(manageFlightVC, animated: true)
            }
        }else if indexPath.row == 3{
            
            if try! LoginManager.sharedInstance.isLogin(){
                let userinfo = defaults.objectForKey("userInfo")
                showHud()
                
                FireFlyProvider.request(.RetrieveBookingList(userinfo!["username"] as! String, userinfo!["password"] as! String, "check_in"), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            self.hideHud()
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                                let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginMobileCheckinVC") as! LoginMobileCheckinViewController
                                mobileCheckinVC.userId = "\(json["user_id"])"
                                mobileCheckinVC.signature = json["signature"].string!
                                mobileCheckinVC.listBooking = json["list_booking"].arrayObject!
                                self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                            }else{
                                self.showToastMessage(json["message"].string!)
                            }
                        }
                        catch {
                            
                        }
                        print (successResult.data)
                    case .Failure(let failureResult):
                        print (failureResult)
                    }
                })
                
            }else{
                
                let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("MobileCheckInVC") as! MobileCheckinViewController
                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                
            }
            
            
        }else if indexPath.row == 4{
            /*let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
            let boardingPassVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassVC") as! BoardingPassViewController
            self.navigationController!.pushViewController(boardingPassVC, animated: true)*/
            
            let date = NSDate()
            let addtime = date.dateByAddingTimeInterval(1.0 * 30.0)
            
            let notification = UILocalNotification()
            if #available(iOS 8.2, *) {
                notification.alertTitle = "Firefly"
            } else {
                // Fallback on earlier versions
            }
            
            notification.userInfo = ["identifier" : "geofence"]
            
            notification.fireDate = addtime
            
            notification.category = "Check_Bluetooth"
            notification.alertBody = "Welcome To Subang Airport. Please turn on Bluetooth for better experience."
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            let storyboard = UIStoryboard(name: "Beacon", bundle: nil)
            let boardingPassVC = storyboard.instantiateViewControllerWithIdentifier("BeaconQRCodeVC") as! BeaconQRCodeViewController
            self.navigationController!.presentViewController(boardingPassVC, animated: true, completion: nil)
        }
    }
    
    func refreshTable(sender: NSNotification){
        self.homeMenuTableView.reloadData()
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
