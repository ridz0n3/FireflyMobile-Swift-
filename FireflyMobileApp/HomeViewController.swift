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
import SlideMenuControllerSwift
import Crashlytics


class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SlideMenuControllerDelegate {
    
    @IBOutlet weak var homeMenuTableView: UITableView!
    
    var menuTitle:[String] = ["","LabelHomeBookFlight".localized, "LabelHomeManageFlight".localized, "LabelHomeMobileCheckIn".localized, "LabelHomeBoardingPass".localized,""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        
        if defaults.objectForKey("notif") != nil{
            if defaults.objectForKey("notif")?.classForCoder != NSString.classForCoder(){
                let userInfo = defaults.objectForKey("notif")
                let alert = userInfo!["aps"]!
                let message = alert!["alert"]!!
                
                showNotif(message["title"] as! String, message : message["body"] as! String)
            }
        }
        
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
            //Crashlytics.sharedInstance().crash()
            if (defaults.objectForKey("module") != nil){
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
            }
            
            
            
        }else if indexPath.row == 1{
            
            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
            let bookFlightVC = storyboard.instantiateViewControllerWithIdentifier("BookFlightVC") as! SearchFlightViewController
            self.navigationController!.pushViewController(bookFlightVC, animated: true)
            
        }else if indexPath.row == 2{
            if try! LoginManager.sharedInstance.isLogin(){
                let userinfo = defaults.objectForKey("userInfo") as! NSDictionary//[String: String]
                showLoading()
                
                FireFlyProvider.request(.RetrieveBookingList(userinfo["username"]! as! String, userinfo["password"]! as! String, "manage_booking", defaults.objectForKey("customer_number") as! String), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            var activeFlight = [AnyObject]()
                            var notActiveFlight = [AnyObject]()
                            if json["status"] == "success"{
                                if json["list_booking"].count != 0{
                                    
                                    for data in json["list_booking"].arrayObject!{
                                        let formater = NSDateFormatter()
                                        formater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
                                        
                                        let twentyFour = NSLocale(localeIdentifier: "en_GB")
                                        formater.locale = twentyFour
                                        let newDate = formater.dateFromString(data["departure_datetime"] as! String)
                                        let today = NSDate()
                                        if today.compare(newDate!) == NSComparisonResult.OrderedAscending{
                                            activeFlight.append(data)
                                        }else{
                                            notActiveFlight.append(data)
                                        }
                                    }
                                    
                                    var newFormatedBookingList = [String : AnyObject]()
                                    newFormatedBookingList.updateValue(activeFlight, forKey: "Active")
                                    newFormatedBookingList.updateValue(notActiveFlight, forKey: "notActive")
                                    /*
                                    if activeFlight.count != 0 && notActiveFlight.count != 0{
                                        newFormatedBookingList.updateValue(activeFlight, forKey: "Active")
                                        newFormatedBookingList.updateValue(notActiveFlight, forKey: "notActive")
                                    }else if activeFlight.count != 0 && notActiveFlight.count == 0{
                                        newFormatedBookingList.updateValue(activeFlight, forKey: "Active")
                                    }else if activeFlight.count == 0 && notActiveFlight.count != 0{
                                        newFormatedBookingList.updateValue(activeFlight, forKey: "notActive")
                                    }*/
                                    //print(newFormatedBookingList)
                                    
                                    let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                    let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("LoginManageFlightVC") as! LoginManageFlightViewController
                                    manageFlightVC.userId = "\(json["user_id"])"
                                    manageFlightVC.signature = json["signature"].string!
                                    manageFlightVC.listBooking = json["list_booking"].arrayObject!
                                    manageFlightVC.groupBookingList = newFormatedBookingList
                                    self.navigationController!.pushViewController(manageFlightVC, animated: true)
                                }else{
                                    
                                    // Create custom Appearance Configuration
                                    let appearance = SCLAlertView.SCLAppearance(
                                        kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                        showCircularIcon: true,
                                        kCircleIconHeight: 40
                                    )
                                    let alertViewIcon = UIImage(named: "alertIcon")
                                    let alert = SCLAlertView(appearance:appearance)
                                    alert.showInfo("Manage Flight", subTitle: "You have no flight record. Please booking your flight to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue", circleIconImage: alertViewIcon)
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
                
                let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
                var userData : Results<UserList>! = nil
                userData = realm.objects(UserList)
                let mainUser = userData.filter("userId == %@", userInfo["username"]! as! String)
                
                if mainUser.count != 0{
                    
                    if mainUser[0].checkinList.count == 0{
                        showLoading()
                        retrieveCheckInList(false)
                    }else{
                        let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                        let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginMobileCheckinVC") as! LoginMobileCheckinViewController
                        mobileCheckinVC.module = "checkIn"
                        mobileCheckinVC.userId = mainUser[0].id
                        mobileCheckinVC.signature = mainUser[0].signature
                        mobileCheckinVC.checkInList = mainUser[0].checkinList.sorted("departureDateTime", ascending: false)
                        self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                        retrieveCheckInList(true)
                    }
                    
                }else{
                    showLoading()
                    retrieveCheckInList(false)
                }
                
            }else{
                
                let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("MobileCheckInVC") as! MobileCheckinViewController
                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                
            }
            
            
        }else if indexPath.row == 4{
            
            if try! LoginManager.sharedInstance.isLogin(){
                
                let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
                var userData : Results<UserList>! = nil
                userData = realm.objects(UserList)
                let mainUser = userData.filter("userId == %@", userInfo["username"]! as! String)
                
                if mainUser.count != 0{
                    
                    if mainUser[0].pnr.count == 0{
                        showLoading()
                        retrieveBoardingList(false)
                    }else{
                        let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                        let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginBoardingPassVC") as! LoginBoardingPassViewController
                        mobileCheckinVC.module = "boardingPass"
                        mobileCheckinVC.userId = mainUser[0].id
                        mobileCheckinVC.signature = mainUser[0].signature
                        mobileCheckinVC.pnrList = mainUser[0].pnr.sorted("departureDateTime", ascending: false)
                        self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                        retrieveBoardingList(true)
                    }
                }else{
                    showLoading()
                    retrieveBoardingList(false)
                }
                
            }else{
                
                let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                let boardingPassVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassVC") as! BoardingPassViewController
                self.navigationController!.pushViewController(boardingPassVC, animated: true)
            }
        }
    }
    
    func retrieveBoardingList(isExist : Bool){
        let userinfo = defaults.objectForKey("userInfo") as! NSDictionary
        //showLoading()
        FireFlyProvider.request(.RetrieveBookingList(userinfo["username"]! as! String, userinfo["password"]! as! String, "boarding_pass", defaults.objectForKey("customer_number") as! String), completion: { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        if json["list_booking"].count != 0{
                            self.saveBoardingPassList(json["list_booking"].arrayObject!, userId: "\(json["user_id"])", signature: json["signature"].string!)
                            
                            if !isExist{
                                let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                                let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginBoardingPassVC") as! LoginBoardingPassViewController
                                mobileCheckinVC.indicator = true
                                mobileCheckinVC.module = "boardingPass"
                                self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                            }else{
                                NSNotificationCenter.defaultCenter().postNotificationName("reloadBoardingPassList", object: nil)
                            }
                        }else{
                            // Create custom Appearance Configuration
                            let appearance = SCLAlertView.SCLAppearance(
                                kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                showCircularIcon: true,
                                kCircleIconHeight: 40
                            )
                            let alertViewIcon = UIImage(named: "alertIcon")
                            let alert = SCLAlertView(appearance:appearance)
                            alert.showInfo("Boarding Pass", subTitle: "You have no boarding pass record. Please check-in your flight ticket to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue", circleIconImage: alertViewIcon)
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
                
                if !isExist{
                    let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
                    var userData : Results<UserList>! = nil
                    userData = realm.objects(UserList)
                    let mainUser = userData.filter("userId == %@", userInfo["username"]! as! String)
                    
                    if mainUser.count != 0{
                        
                        if mainUser[0].pnr.count != 0{
                            let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
                            let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginBoardingPassVC") as! LoginBoardingPassViewController
                            mobileCheckinVC.indicator = true
                            mobileCheckinVC.module = "boardingPass"
                            //mobileCheckinVC.pnrList = mainUser[0].pnr.sorted("departureDateTime", ascending: false)
                            self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                        }else{
                            // Create custom Appearance Configuration
                            let appearance = SCLAlertView.SCLAppearance(
                                kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                showCircularIcon: true,
                                kCircleIconHeight: 40
                            )
                            let alertViewIcon = UIImage(named: "alertIcon")
                            let alert = SCLAlertView(appearance:appearance)
                            alert.showInfo("Boarding Pass", subTitle: "You have no boarding pass record. Please check-in your flight ticket to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue", circleIconImage: alertViewIcon)
                        }
                    }else{
                        // Create custom Appearance Configuration
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                            showCircularIcon: true,
                            kCircleIconHeight: 40
                        )
                        let alertViewIcon = UIImage(named: "alertIcon")
                        let alert = SCLAlertView(appearance:appearance)
                        alert.showInfo("Boarding Pass", subTitle: "You have no boarding pass record. Please check-in your flight ticket to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue", circleIconImage:alertViewIcon)
                    }
                }else{
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadBoardingPassList", object: nil)
                }
                
            }
        })
        
    }
    
    func saveBoardingPassList(list : [AnyObject], userId : String, signature : String){
        
        let userInfo = defaults.objectForKey("userInfo")
        var userList = Results<UserList>!()
        userList = realm.objects(UserList)
        
        for listInfo in list{
            
            let mainUser = userList.filter("userId == %@",userInfo!["username"] as! String)
            let pnr = PNRList()
            pnr.pnr = listInfo["pnr"] as! String
            
            let formater = NSDateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            let twentyFour = NSLocale(localeIdentifier: "en_GB")
            formater.locale = twentyFour
            let date = (listInfo["date"] as! String).componentsSeparatedByString(" ")
            let new = "\(date[2])-\(date[1])-\(date[0])"
            let newdate = formater.dateFromString(new)
            //print(newdate)
            
            pnr.departureStationCode = listInfo["departure_station_code"] as! String
            pnr.arrivalStationCode = listInfo["arrival_station_code"] as! String
            pnr.departureDateTime = newdate!
            pnr.departureDayDate = listInfo["date"] as! String
            
            if mainUser.count == 0{
                let user = UserList()
                user.userId = userInfo!["username"] as! String
                user.pnr.append(pnr)
                
                try! realm.write({ () -> Void in
                    realm.add(user)
                })
            }else{
                let mainPNR = mainUser[0].pnr.filter("pnr == %@", pnr.pnr)
                if mainPNR.count != 0{
                    
                    for pnrData in mainPNR{
                        
                        if (pnrData.pnr == pnr.pnr) && pnrData.departureStationCode == pnr.departureStationCode{
                            
                            if pnrData.boardingPass.count != 0{
                                
                                for boardingInfo in pnrData.boardingPass{
                                    let boardingPass = BoardingPassList()
                                    boardingPass.name = boardingInfo.name
                                    boardingPass.departureStation = boardingInfo.departureStation
                                    boardingPass.arrivalStation = boardingInfo.arrivalStation
                                    boardingPass.departureDate = boardingInfo.departureDate
                                    boardingPass.departureTime = boardingInfo.departureTime
                                    boardingPass.boardingTime = boardingInfo.boardingTime
                                    boardingPass.fare = boardingInfo.fare
                                    boardingPass.flightNumber = boardingInfo.flightNumber
                                    boardingPass.SSR = boardingInfo.SSR
                                    boardingPass.QRCodeURL = boardingInfo.QRCodeURL
                                    boardingPass.recordLocator = boardingInfo.recordLocator
                                    boardingPass.arrivalStationCode = boardingInfo.arrivalStationCode
                                    boardingPass.departureStationCode = boardingInfo.departureStationCode
                                    
                                    pnr.boardingPass.append(boardingPass)
                                }
                                
                            }
                            
                            realm.beginWrite()
                            realm.delete(pnrData)
                            try! realm.commitWrite()
                        }
                        
                    }
                    
                }
                
                try! realm.write({ () -> Void in
                    mainUser[0].pnr.append(pnr)
                    mainUser[0].id = userId
                    mainUser[0].signature = signature
                })
                
            }
            
        }
    }
    
    func refreshTable(sender: NSNotification){
        self.homeMenuTableView.reloadData()
    }
    
    func retrieveCheckInList(isExist : Bool){
        
        let userinfo = defaults.objectForKey("userInfo") as! NSDictionary
        FireFlyProvider.request(.RetrieveBookingList(userinfo["username"]! as! String, userinfo["password"]! as! String, "check_in", defaults.objectForKey("customer_number") as! String), completion: { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        if json["list_booking"].count != 0{
                            
                            self.saveCheckInList(json["list_booking"].arrayObject!, userId: "\(json["user_id"])", signature: json["signature"].string!)
                            
                            if !isExist{
                                let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                                let mobileCheckinVC = storyboard.instantiateViewControllerWithIdentifier("LoginMobileCheckinVC") as! LoginMobileCheckinViewController
                                mobileCheckinVC.indicator = true
                                mobileCheckinVC.module = "checkIn"
                                self.navigationController!.pushViewController(mobileCheckinVC, animated: true)
                                hideLoading()
                            }else{
                                NSNotificationCenter.defaultCenter().postNotificationName("reloadCheckInList", object: nil)
                            }
                        }else{
                            hideLoading()
                            // Create custom Appearance Configuration
                            let appearance = SCLAlertView.SCLAppearance(
                                kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                showCircularIcon: true,
                                kCircleIconHeight: 40
                            )
                            let alertViewIcon = UIImage(named: "alertIcon")
                            let alert = SCLAlertView(appearance:appearance)
                            alert.showInfo("Mobile Check-In", subTitle: "You have no flight record. Please booking your flight to proceed", colorStyle:0xEC581A, closeButtonTitle : "Continue", circleIconImage: alertViewIcon)
                        }
                    }else if json["status"] == "error"{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                    }
                    
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                
                if !isExist{
                    hideLoading()
                    showErrorMessage(failureResult.nsError.localizedDescription)
                }else{
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadCheckInList", object: nil)
                }
                //
            }
        })
        
    }
    
    func saveCheckInList(list : NSArray, userId : String, signature : String){
        
        let userInfo = defaults.objectForKey("userInfo")
        var userList = Results<UserList>!()
        userList = realm.objects(UserList)
        let mainUser = userList.filter("userId == %@",userInfo!["username"] as! String)
        
        if mainUser.count != 0{
            if mainUser[0].checkinList.count != 0{
                realm.beginWrite()
                realm.delete(mainUser[0].checkinList)
                try! realm.commitWrite()
            }
        }
        
        for listInfo in list{
            
            let checkIn = CheckInList()
            checkIn.pnr = listInfo["pnr"] as! String
            
            let formater = NSDateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            let twentyFour = NSLocale(localeIdentifier: "en_GB")
            formater.locale = twentyFour
            let date = (listInfo["date"] as! String).componentsSeparatedByString(" ")
            let new = "\(date[2])-\(date[1])-\(date[0])"
            let newdate = formater.dateFromString(new)
            //print(newdate)
            
            checkIn.departureStationCode = listInfo["departure_station_code"] as! String
            checkIn.arrivalStationCode = listInfo["arrival_station_code"] as! String
            checkIn.departureDateTime = newdate!
            checkIn.departureDayDate = listInfo["date"] as! String
            
            if mainUser.count == 0{
                let user = UserList()
                user.userId = userInfo!["username"] as! String
                user.checkinList.append(checkIn)
                
                try! realm.write({ () -> Void in
                    realm.add(user)
                })
            }else{
                
                try! realm.write({ () -> Void in
                    mainUser[0].checkinList.append(checkIn)
                    mainUser[0].id = userId
                    mainUser[0].signature = signature
                })
                
            }
        }
        
    }
    
}
