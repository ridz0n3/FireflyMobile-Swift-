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

class AddFlightDetailViewController: CommonFlightDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        var userInfo = NSMutableDictionary()
        
        if try! LoginManager.sharedInstance.isLogin(){
            userInfo = defaults.objectForKey("userInfo") as! NSMutableDictionary
        }
        
        let date = flightDetail[0]["departure_date"].string!
        var dateArr = date.componentsSeparatedByString(" ")
        var planGo = String()
        var planBack = String()
        
        if planGoing == 1{
            planGo = "basic_class"
        }else{
            planGo = "flex_class"
        }
        
        if !isGoingSelected{
            self.showToastMessage("Please select Going Flight")
        }else if !isReturnSelected && defaults.objectForKey("type")! as! NSNumber != 0{
            self.showToastMessage("Please select Return Flight")
        }else if planGo == "flex_class" && flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["status"].string == "sold out"{
            self.showToastMessage("Please select Going Flight")
        }else{
            
            var isType1 = false
            var isError = false
            
            var infant = String()
            var adult = String()
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
            
            if defaults.objectForKey("type") as! Int == 1{
                
                let dateReturn = flightDetail[1]["departure_date"].string!
                var dateReturnArr = dateReturn.componentsSeparatedByString(" ")
                
                if planReturn == 4{
                    planBack = "basic_class"
                }else{
                    planBack = "flex_class"
                }
                
                if planBack == "flex_class" && flightDetail[1]["flights"][selectedReturnFlight.integerValue][planBack]["status"].string == "sold out"{
                    
                    self.showToastMessage("Please select Return Flight")
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
                
                type = defaults.objectForKey("type")! as! Int
                
                if userInfo["username"] != nil{
                    username = userInfo["username"]! as! String
                }
                
                departure_station = flightDetail[0]["departure_station_code"].string!
                arrival_station = flightDetail[0]["arrival_station_code"].string!
                departure_date = formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"))
                adult = defaults.objectForKey("adult")! as! String
                infant = defaults.objectForKey("infant")! as! String
                flight_number_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["flight_number"].string!
                departure_time_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["departure_time"].string!
                arrival_time_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["arrival_time"].string!
                journey_sell_key_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["journey_sell_key"].string!
                fare_sell_key_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["fare_sell_key"].string!
                
                showHud()
                FireFlyProvider.request(.SelectFlight(adult, infant, username, type, departure_date, arrival_time_1, departure_time_1, fare_sell_key_1, flight_number_1, journey_sell_key_1, return_date, arrival_time_2, departure_time_2, fare_sell_key_2, flight_number_2, journey_sell_key_2, departure_station, arrival_station), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            self.hideHud()
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                defaults.setObject(json["booking_id"].int , forKey: "booking_id")
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let personalDetailVC = storyboard.instantiateViewControllerWithIdentifier("PassengerDetailVC") as! AddPassengerDetailViewController
                                self.navigationController!.pushViewController(personalDetailVC, animated: true)
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
