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
import SCLAlertView
import RealmSwift

class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var homeMenuTableView: UITableView!
    
    var menuTitle:[String] = ["","LabelHomeBookFlight".localized, "LabelHomeManageFlight".localized, "LabelHomeMobileCheckIn".localized, "LabelHomeBoardingPass".localized,""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.refreshTable(_:)), name: "reloadHome", object: nil)
        AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Get the URL from Backend
    func facebookSelected(sender: UIGestureRecognizer) {
        //AnalyticsManager.sharedInstance.logScreen(GAConstants.facebookScreen)
        let facebookHooks = "fb://profile/\(defaults.objectForKey("facebook") as! String)"
        let facebookURL = NSURL(string: facebookHooks)
        if UIApplication.sharedApplication().canOpenURL(facebookURL!)
        {
            UIApplication.sharedApplication().openURL(facebookURL!)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/\(defaults.objectForKey("facebook") as! String)")!)
        }
    }
    
    func instaSelected(sender: UIGestureRecognizer) {
        //AnalyticsManager.sharedInstance.logScreen(GAConstants.instagramScreen)
        let instagramHooks = "instagram://user?username=\(defaults.objectForKey("instagram") as! String)"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.sharedApplication().canOpenURL(instagramUrl!)
        {
            UIApplication.sharedApplication().openURL(instagramUrl!)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.instagram.com/\(defaults.objectForKey("instagram") as! String)")!)
        }
    }
    
    func twitterSelected(sender: UIGestureRecognizer) {
        //AnalyticsManager.sharedInstance.logScreen(GAConstants.twitterScreen)
        let twitterHooks = "twitter:///user?screen_name=\(defaults.objectForKey("twitter") as! String)"
        let twitterUrl = NSURL(string: twitterHooks)
        if UIApplication.sharedApplication().canOpenURL(twitterUrl!)
        {
            UIApplication.sharedApplication().openURL(twitterUrl!)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/\(defaults.objectForKey("twitter") as! String)")!)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return self.view.frame.size.width
            
        }
        else if indexPath.row == 5 {
            
            return 38
            
        }else {
            
            return 55
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
        }
        else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier("SocialCell", forIndexPath: indexPath)
            let facebookView = cell.viewWithTag(1)
            let facebookSelected = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.facebookSelected(_:)))
            facebookView?.addGestureRecognizer(facebookSelected)
            let twitterSelected = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.twitterSelected(_:)))
            let twitterView = cell.viewWithTag(2)
            twitterView?.addGestureRecognizer(twitterSelected)
            let instaView = cell.viewWithTag(3)
            let instaSelected = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.instaSelected(_:)))
            instaView?.addGestureRecognizer(instaSelected)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomHomeMenuTableViewCell
            
            let replaced = menuTitle[indexPath.row].stringByReplacingOccurrencesOfString(" ", withString: "")
            
            cell.bgView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
            cell.menuLbl?.text = menuTitle[indexPath.row]
            cell.menuIcon.image = UIImage(named: replaced)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0{
            
            if defaults.objectForKey("module") as! String == "faq"{
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let FAQVC = storyboard.instantiateViewControllerWithIdentifier("FAQVC") as! FAQViewController
                FAQVC.secondLevel = true
                self.navigationController!.pushViewController(FAQVC, animated: true)
            }else{
                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                let bookFlightVC = storyboard.instantiateViewControllerWithIdentifier("BookFlightVC") as! SearchFlightViewController
                self.navigationController!.pushViewController(bookFlightVC, animated: true)
            }
            
            
        }else if indexPath.row == 1{
            
            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
            let bookFlightVC = storyboard.instantiateViewControllerWithIdentifier("BookFlightVC") as! SearchFlightViewController
            self.navigationController!.pushViewController(bookFlightVC, animated: true)
            
        }else if indexPath.row == 2{
            if try! LoginManager.sharedInstance.isLogin(){
                let userinfo = defaults.objectForKey("userInfo") as! [String: String]
                showLoading() 
                
                FireFlyProvider.request(.RetrieveBookingList(userinfo["username"]!, userinfo["password"]!, "manage_booking"), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                if json["list_booking"].count != 0{
                                    let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                    let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("LoginManageFlightVC") as! LoginManageFlightViewController
                                    manageFlightVC.userId = "\(json["user_id"])"
                                    manageFlightVC.signature = json["signature"].string!
                                    manageFlightVC.listBooking = json["list_booking"].arrayObject!
                                    self.navigationController!.pushViewController(manageFlightVC, animated: true)
                                }else{
                                    let alert = SCLAlertView()
                                    alert.showInfo("Manage Flight", subTitle: "You have no flight record. Please booking your flight to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue")
                                }
                            }else if json["status"] == "error"{
                                
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
                })
                
            }else{
                
                let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightVC") as! ManageFlightViewController
                self.navigationController!.pushViewController(manageFlightVC, animated: true)
            }
        }else if indexPath.row == 3{
            
            if try! LoginManager.sharedInstance.isLogin(){
                let userinfo = defaults.objectForKey("userInfo") as! [String: String]
                showLoading() 
                
                FireFlyProvider.request(.RetrieveBookingList(userinfo["username"]!, userinfo["password"]!, "check_in"), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                if json["list_booking"].count != 0{
                                    let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                                    let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginMobileCheckinVC") as! LoginMobileCheckinViewController
                                    mobileCheckinVC.userId = "\(json["user_id"])"
                                    mobileCheckinVC.signature = json["signature"].string!
                                    mobileCheckinVC.listBooking = json["list_booking"].arrayObject!
                                    self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                                }else{
                                    let alert = SCLAlertView()
                                    alert.showInfo("Mobile Check-In", subTitle: "You have no flight record. Please booking your flight to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue")
                                }
                            }else if json["status"] == "error"{
                                
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
                })
                
            }else{
                
                let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("MobileCheckInVC") as! MobileCheckinViewController
                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                
            }
            
            
        }else if indexPath.row == 4{
            
            if try! LoginManager.sharedInstance.isLogin(){
                let userinfo = defaults.objectForKey("userInfo") as! [String : String]
                showLoading() 
                
                FireFlyProvider.request(.RetrieveBookingList(userinfo["username"]!, userinfo["password"]!, "boarding_pass"), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                if json["list_booking"].count != 0{
                                    let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                                    let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginBoardingPassVC") as! LoginBoardingPassViewController
                                    mobileCheckinVC.userId = "\(json["user_id"])"
                                    mobileCheckinVC.signature = json["signature"].string!
                                    mobileCheckinVC.listBooking = json["list_booking"].arrayObject!
                                    self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                                }else{
                                    let alert = SCLAlertView()
                                    alert.showInfo("Boarding Pass", subTitle: "You have no boarding pass record. Please check-in your flight ticket to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue")
                                }
                            }else if json["status"] == "error"{
                                
                                showErrorMessage(json["message"].string!)
                            }
                            hideLoading()
                        }
                        catch {
                            
                        }
                        
                    case .Failure:
                        
                        hideLoading()
                        //showErrorMessage(failureResult.nsError.localizedDescription)
                        let userInfo = defaults.objectForKey("userInfo") as! [String : String]
                        var userData : Results<UserList>! = nil
                        userData = realm.objects(UserList)
                        let mainUser = userData.filter("userId == %@", userInfo["username"]!)
                        
                        if mainUser.count != 0{
                            
                            let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                            let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginBoardingPassVC") as! LoginBoardingPassViewController
                            mobileCheckinVC.isOffline = true
                            mobileCheckinVC.pnrList = mainUser[0].pnr.sorted("departureDateTime", ascending: false)
                            self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                            print(mainUser[0].pnr.count)
                        }else{
                            let alert = SCLAlertView()
                            alert.showInfo("Boarding Pass", subTitle: "You have no boarding pass record. Please check-in your flight ticket to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue")
                        }
                        
                        
                    }
                })
                
            }else{
                
                let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                let boardingPassVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassVC") as! BoardingPassViewController
                self.navigationController!.pushViewController(boardingPassVC, animated: true)
            }
        }
    }
    
    func refreshTable(sender: NSNotification){
        self.homeMenuTableView.reloadData()
    }
    
}
