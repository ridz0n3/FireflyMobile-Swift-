//
//  AddMHFlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/28/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON
import M13Checkbox

class AddMHFlightDetailViewController: CommonMHFlightDetailViewController {

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
        AnalyticsManager.sharedInstance.logScreen(GAConstants.mhFlightDetailsScreen)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        var userInfo = NSMutableDictionary()
        var planGo = String()
        var planBack = String()
        
        if try! LoginManager.sharedInstance.isLogin(){
            userInfo = defaults.objectForKey("userInfo") as! NSMutableDictionary
        }
        
        let date = flightDetail[0]["departure_date"].string!
        var dateArr = date.componentsSeparatedByString(" ")
        var isReturn = Bool()
        
        if flightDetail.count == 2{
            isReturn = true
        }
        
        if checkGoingIndex == ""{
            showErrorMessage("LabelErrorGoingFlight".localized)
        }else if isReturn && checkReturnIndex == ""{
            showErrorMessage("LabelErrorReturnFlight".localized)
        }else if termCheckBox.checkState != M13CheckboxState.Checked{
            showErrorMessage("You must agree to the terms and conditions.")
        }else{
            
            if defaults.objectForKey("type") as! Int == 1{
                let dateReturn = flightDetail[1]["departure_date"].string!
                var dateReturnArr = dateReturn.componentsSeparatedByString(" ")
                
                if checkReturnIndex == "1"{
                    planBack = "economy_promo_class"
                }else if checkReturnIndex == "2"{
                    planBack = "economy_class"
                }else{
                    planBack = "business_class"
                }
                
                return_date = formatDate(stringToDate("\(dateReturnArr[2])-\(dateReturnArr[1])-\(dateReturnArr[0])"))
                flight_number_2 = flightDetail[1]["flights"][checkReturnIndexPath.row]["flight_number"].string!
                departure_time_2 = flightDetail[1]["flights"][checkReturnIndexPath.row]["departure_time"].string!
                arrival_time_2 = flightDetail[1]["flights"][checkReturnIndexPath.row]["arrival_time"].string!
                journey_sell_key_2 = flightDetail[1]["flights"][checkReturnIndexPath.row]["journey_sell_key"].string!
                fare_sell_key_2 = flightDetail[1]["flights"][checkReturnIndexPath.row][planBack]["fare_sell_key"].string!
                
                let formater = NSDateFormatter()
                formater.dateFormat = "hh:mm a"
                let time1 = formater.dateFromString(departure_time_2)
                let time2 = formater.dateFromString(arrival_time_2)
                let timeDifference = NSCalendar.currentCalendar().components(.Hour, fromDate: time1!, toDate: time2!, options: []).hour
                //print(timeDifference)
                
            }
            
            if checkGoingIndex == "1"{
                planGo = "economy_promo_class"
            }else if checkGoingIndex == "2"{
                planGo = "economy_class"
            }else{
                planGo = "business_class"
            }
            
            type = defaults.objectForKey("type")! as! Int
            
            if userInfo["username"] != nil{
                username = userInfo["username"]! as! String
            }
            
            departure_station = flightDetail[0]["departure_station_code"].string!
            arrival_station = flightDetail[0]["arrival_station_code"].string!
            departure_date = formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"))
            adult = defaults.objectForKey("adult")! as! String
            infant = defaults.objectForKey("infants")! as! String
            flight_number_1 = flightDetail[0]["flights"][checkGoingIndexPath.row]["flight_number"].string!
            departure_time_1 = flightDetail[0]["flights"][checkGoingIndexPath.row]["departure_time"].string!
            arrival_time_1 = flightDetail[0]["flights"][checkGoingIndexPath.row]["arrival_time"].string!
            journey_sell_key_1 = flightDetail[0]["flights"][checkGoingIndexPath.row]["journey_sell_key"].string!
            fare_sell_key_1 = flightDetail[0]["flights"][checkGoingIndexPath.row][planGo]["fare_sell_key"].string!
            
            let formater = NSDateFormatter()
            formater.dateFormat = "hh:mm a"
            let time1 = formater.dateFromString(departure_time_1)
            let time2 = formater.dateFromString(arrival_time_1)
            let timeDifference = NSCalendar.currentCalendar().components(.Hour, fromDate: time1!, toDate: time2!, options: []).hour
            
            defaults.setValue(timeDifference, forKey: "timeDifference")
            defaults.synchronize()
            
            //print(timeDifference)
            
            if try! LoginManager.sharedInstance.isLogin(){
                showLoading()
                sentData()
                
            }else{
                
                reloadAlertView("Please insert your detail")
                
            }
        }
        
    }

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
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if  json["status"].string == "success"{
                            
                            defaults.setObject(json["user_info"]["signature"].string, forKey: "signatureLoad")
                            defaults.setObject(json["user_info"].object , forKey: "userInfo")
                            defaults.setObject(json["user_info"]["customer_number"].string, forKey: "customer_number")
                            defaults.synchronize()
                            
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
                    
                case .Failure(let failureResult):
                    
                    hideLoading()
                    showErrorMessage(failureResult.nsError.localizedDescription)
                }
                //var success = error == nil
                }
            )
        }
        
    }
    
    func reloadAlertView(msg : String){
        
        let alert = SCLAlertView()
        email = alert.addTextField("Enter email")
        email.text = tempEmail
        password = alert.addTextField("Password")
        password.secureTextEntry = true
        password.text = tempPassword
        alert.addButton("Login", target: self, selector: #selector(AddMHFlightDetailViewController.loginBtnPressed(_:)))
        //alert.showCloseButton = false
        alert.addButton("Continue as guest") {
            showLoading()
            self.sentData()
        }
        alert.showEdit("Login", subTitle: msg, colorStyle: 0xEC581A, closeButtonTitle : "Close")
        
    }
    
    func sentData(){
        
        FireFlyProvider.request(.SelectFlight(adult, infant, username, type, departure_date, arrival_time_1, departure_time_1, fare_sell_key_1, flight_number_1, journey_sell_key_1, return_date, arrival_time_2, departure_time_2, fare_sell_key_2, flight_number_2, journey_sell_key_2, departure_station, arrival_station), completion: { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        defaults.setObject(json["booking_id"].int , forKey: "booking_id")
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let personalDetailVC = storyboard.instantiateViewControllerWithIdentifier("PassengerDetailVC") as! AddPassengerDetailViewController
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
                
            case .Failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.nsError.localizedDescription)
            }
            
        })
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
