//
//  AddFlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/25/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import M13Checkbox
import SCLAlertView
import RealmSwift
import Crashlytics

class AddFlightDetailViewController: CommonFlightDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rule = "<b>FlyBasic</b><ol><li>This fare is capacity controlled. Seats offered at this fare are limited and may not be available on all flights. All fares are subject to change until purchased.</li><li>Name Change is not permitted.</li><li>Date Change is permitted with payment of fee and fare difference more than 2 hours prior to departure.</li><li>Route Change is not permitted.</li><li>Refund is not permitted. Reservations cannot be cancelled once confirmed.</li><li>For full set of applicable fees, taxes and surcharges, please visit our 'Fees' webpage.</li><li>For general term and conditions, please refer to Firefly General Conditions of Carriage.</li></ol>"
        
        let term = "I confirm, understand and accept Firefly's General Conditions of Carriage. Fare Rules and confirm that the passenger(s) in my reservation does not require Special Assistance and are not categorised as Unaccompanied Minor(s)."
        
        
        fareRule.attributedText = rule.html2String
        fareRule.font = UIFont(name: "System Semibold", size: 14)
        termCondition.attributedText = term.html2String
        termCondition.font = UIFont(name: "System Semibold", size: 14)
        termCheckBox.strokeColor = UIColor.orangeColor()
        termCheckBox.checkColor = UIColor.orangeColor()
        
        var newFrame = continueView.bounds
        newFrame.size.height = 490
        continueView.frame = newFrame
        
        self.flightDetailTableView.tableFooterView = continueView
        let flightType = defaults.object(forKey: "flightType") as! String
        AnalyticsManager.sharedInstance.logScreen("\(GAConstants.flightDetailsScreen) (\(flightType))")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        var userInfo = NSMutableDictionary()
        
        if try! LoginManager.sharedInstance.isLogin(){
            userInfo = defaults.object(forKey: "userInfo") as! NSMutableDictionary
        }
        
        let date = flightDetail[0]["departure_date"].string!
        var dateArr = date.components(separatedBy: " ")
        var planGo = String()
        var planBack = String()
        
        if planGoing == 1{
            planGo = "basic_class"
        }else{
            planGo = "flex_class"
        }
        
        if !isGoingSelected{
            showErrorMessage("LabelErrorGoingFlight".localized)
        }else if !isReturnSelected && defaults.object(forKey: "type")! as! NSNumber != 0{
            showErrorMessage("LabelErrorReturnFlight".localized)
        }else if planGo == "flex_class" && flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["status"].string == "sold out"{
            showErrorMessage("LabelErrorGoingFlight".localized)
        }else if termCheckBox.checkState == M13CheckboxState.Unchecked{
            showErrorMessage("You must agree to the terms and conditions.")
        }else{
            
            var isType1 = false
            var isError = false
            
            if defaults.object(forKey: "type") as! Int == 1{
                
                let dateReturn = flightDetail[1]["departure_date"].string!
                var dateReturnArr = dateReturn.components(separatedBy: " ")
                
                if planReturn == 4{
                    planBack = "basic_class"
                }else{
                    planBack = "flex_class"
                }
                
                if planBack == "flex_class" && flightDetail[1]["flights"][selectedReturnFlight.integerValue][planBack]["status"].string == "sold out"{
                    
                    showErrorMessage("LabelErrorReturnFlight".localized)
                    isError = true
                }else{
                    
                    return_date = formatDate(stringToDate("\(dateReturnArr[2])-\(dateReturnArr[1])-\(dateReturnArr[0])"))
                    flight_number_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue]["flight_number"].string!
                    departure_time_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue]["departure_time"].string!
                    arrival_time_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue]["arrival_time"].string!
                    journey_sell_key_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue]["journey_sell_key"].string!
                    fare_sell_key_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue][planBack]["fare_sell_key"].string!
                    
                }
                isType1 = true
            }
            
            if (isType1 == true && isError == false) || isType1 == false{
                
                type = defaults.object(forKey: "type")! as! Int
                
                if userInfo["username"] != nil{
                    username = userInfo["username"]! as! String
                }
                
                departure_station = flightDetail[0]["departure_station_code"].string!
                arrival_station = flightDetail[0]["arrival_station_code"].string!
                departure_date = formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"))
                adult = defaults.object(forKey: "adult")! as! String
                infant = defaults.object(forKey: "infants")! as! String
                flight_number_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["flight_number"].string!
                departure_time_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["departure_time"].string!
                arrival_time_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["arrival_time"].string!
                journey_sell_key_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["journey_sell_key"].string!
                fare_sell_key_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["fare_sell_key"].string!
                
                if try! LoginManager.sharedInstance.isLogin(){
                    showLoading()
                    sentData()
                }else{
                    
                    reloadAlertView("Please insert your detail")
                    
                }
                
            }
            
        }
        
    }
    var email = UITextField()
    var password = UITextField()
    
    var tempEmail = String()
    var tempPassword = String()
    
    var type = Int()
    var username = String()
    var departure_station = String()
    var arrival_station = String()
    var departure_date = String()
    var arrival_time_1 = String()
    var departure_time_1 = String()
    var fare_sell_key_1 = String()
    var flight_number_1 = String()
    var journey_sell_key_1 = String()
    
    var return_date = String()
    var arrival_time_2 = String()
    var departure_time_2 = String()
    var fare_sell_key_2 = String()
    var flight_number_2 = String()
    var journey_sell_key_2 = String()
    
    func loginBtnPressed(sender : SCLAlertView){
        
        tempEmail = email.text!
        tempPassword = password.text!
        
        if email.text == "" || password.text == ""{
            reloadAlertView("Please fill all field")
        }else{
            let encPassword = try! EncryptManager.sharedInstance.aesEncrypt(password.text!, key: key, iv: iv)
            
            let username: String = email.text!
            
            showLoading()
            FireFlyProvider.request(.Login(username, encPassword), completion: { (result) -> () in
                
                switch result {
                case .success(let successResult):
                    do {
                        //hideLoading()
                        let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                        
                        if  json["status"].string == "success"{
                            
                            defaults.setObject(json["user_info"]["signature"].string, forKey: "signature")
                            defaults.setObject(json["user_info"].object , forKey: "userInfo")
                            defaults.setObject(json["user_info"]["customer_number"].string, forKey: "customer_number")
                            defaults.synchronize()
                            defaults.setObject(json["user_info"]["personID"].string, forKey: "personID")
                            let userInfo = defaults.object(forKey: "userInfo") as! NSMutableDictionary
                            self.username = userInfo["username"]! as! String
                            self.type = defaults.object(forKey: "type")! as! Int
                            Crashlytics.sharedInstance().setUserEmail(self.username)
                            NSNotificationCenter.defaultCenter().postNotificationName("reloadSideMenu", object: nil)
                            
                           self.sentData()
                        }else if json["status"].string == "401"{
                            hideLoading()
                            showErrorMessage(json["message"].string!)
                            InitialLoadManager.sharedInstance.load()
                            
                            for views in (self.navigationController?.viewControllers)!{
                                if views.classForCoder == HomeViewController.classForCoder(){
                                    self.navigationController?.popToViewController(views, animated: true)
                                    AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                }
                            }
                        }else{
                            
                            hideLoading()
                            self.reloadAlertView(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    
                case .failure(let failureResult):
                    
                    hideLoading()
                    showErrorMessage(failureResult.localizedDescription)
                }
                //var success = error == nil
                }
            )
        }
        
    }
    
    func reloadAlertView(msg : String){
        
        // Create custom Appearance Configuration
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCircularIcon: true,
            kCircleIconHeight: 40
        )
        let alertViewIcon = UIImage(named: "alertIcon")
        //AnalyticsManager.sharedInstance.logScreen(GAConstants.loginPopupScreen)
        let alert = SCLAlertView(appearance:appearance)
        email = alert.addTextField("Enter email")
        email.text = tempEmail
        password = alert.addTextField("Password")
        password.secureTextEntry = true
        password.text = tempPassword
        alert.addButton("Login", target: self, selector: #selector(AddFlightDetailViewController.loginBtnPressed(_:)))
        //alert.showCloseButton = false
        alert.addButton("Continue as guest") {
            showLoading()
            self.sentData()
        }
        alert.showEdit("Login", subTitle: msg, colorStyle: 0xEC581A, closeButtonTitle : "Close", circleIconImage: alertViewIcon)
        
        
    }
    
    func sentData(){
        
        FireFlyProvider.request(.SelectFlight(adult, infant, username, type, departure_date, arrival_time_1, departure_time_1, fare_sell_key_1, flight_number_1, journey_sell_key_1, return_date, arrival_time_2, departure_time_2, fare_sell_key_2, flight_number_2, journey_sell_key_2, departure_station, arrival_station), completion: { (result) -> () in
            switch result {
            case .success(let successResult):
                do {
                    
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if json["status"] == "success"{
                        
                        if try! LoginManager.sharedInstance.isLogin(){
                            self.saveFamilyAndFriend(json["family_and_friend"].arrayObject!)
                        }
                        defaults.setObject(json["booking_id"].int , forKey: "booking_id")
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let personalDetailVC = storyboard.instantiateViewControllerWithIdentifier("PassengerDetailVC") as! AddPassengerDetailViewController
                        //personalDetailVC.familyAndFriend = json["family_and_friend"].arrayObject!
                        self.navigationController!.pushViewController(personalDetailVC, animated: true)
                    }else if json["status"] == "error"{
                        
                        showErrorMessage(json["message"].string!)
                    }else if json["status"].string == "401"{
                        hideLoading()
                        showErrorMessage(json["message"].string!)
                        InitialLoadManager.sharedInstance.load()
                        
                        for views in (self.navigationController?.viewControllers)!{
                            if views.classForCoder == HomeViewController.classForCoder(){
                                self.navigationController?.popToViewController(views, animated: true)
                                AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                            }
                        }
                    }
                    hideLoading()
                }
                catch {
                    
                }
                
            case .failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.localizedDescription)
            }
            
        })
    }
    
    func saveFamilyAndFriend(familyAndFriendInfo : [AnyObject]){
        
        let userInfo = defaults.object(forKey: "userInfo")
        var userList = Results<FamilyAndFriendList>!()
        userList = realm.objects(FamilyAndFriendList)
        let mainUser = userList.filter("email == %@",userInfo!["username"] as! String)
        
        if mainUser.count != 0{
            if mainUser[0].familyList.count != 0{
                realm.beginWrite()
                realm.delete(mainUser[0].familyList)
                try! realm.commitWrite()
            }else{
                realm.beginWrite()
                realm.delete(mainUser[0])
                try! realm.commitWrite()
            }
        }
        
        for list in familyAndFriendInfo{
            
            let data = FamilyAndFriendData()
            data.id = list["id"] as! Int
            data.title = list["title"] as! String
            data.gender = nullIfEmpty(list["gender"]) as! String
            data.firstName = list["first_name"] as! String
            data.lastName = list["last_name"] as! String
            //let dateArr = (list["dob"] as! String).components(separatedBy: "-")
            data.dob = list["dob"] as! String//"\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"
            data.country = list["nationality"] as! String
            data.bonuslink = list["bonuslink_card"] as! String
            data.type = list["type"] as! String
            
            if mainUser.count == 0{
                let user = FamilyAndFriendList()
                user.email = userInfo!["username"] as! String
                user.familyList.append(data)
                
                try! realm.write({ () -> Void in
                    realm.add(user)
                })
                
            }else{
                
                try! realm.write({ () -> Void in
                    mainUser[0].familyList.append(data)
                    mainUser[0].email = userInfo!["username"] as! String
                })
                
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
