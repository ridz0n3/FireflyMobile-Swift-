
//
//  FlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import M13Checkbox

class FlightDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var flightDetailTableView: UITableView!
    @IBOutlet weak var continueView: UIView!
    
    var selectedGoingFlight = NSNumber()
    var selectedGoingCell:NSNumber? = nil
    var selectedReturnFlight = NSNumber()
    var selectedReturnCell:NSNumber? = nil
    var flightDetail : Array<JSON> = []
    var infant = String()
    var adult = String()
    var planGoing:Int = 1
    var planReturn:Int = 4
    var flightAvailable = Bool()
    var isGoingSelected = Bool()
    var isReturnSelected = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        self.flightDetailTableView.tableHeaderView = headerView
        isGoingSelected = false
        isReturnSelected = false
        //selectedGoingFlight = NSNumber()
        //selectedReturnFlight = NSNumber()
        flightAvailable = true
        if flightDetail.count == 0{
            self.continueView.hidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if flightDetail.count == 0{
            return 1
        }else{
            return flightDetail.count
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flightDetail.count == 0{
            return 1
        }else{
            let flightDict = flightDetail[section].dictionary
            
            if flightDict!["flights"]?.count == 0{
                return 1
            }else{
                return (flightDict!["flights"]?.count)!
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        return 107
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if flightDetail.count == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("NoFlightCell", forIndexPath: indexPath)
            return cell
        }else{
            
            let flightDict = flightDetail[indexPath.section].dictionary
            
            if flightDict!["flights"]?.count == 0{
                let cell = tableView.dequeueReusableCellWithIdentifier("NoFlightCell", forIndexPath: indexPath)
                return cell
            }else{
                let cell = self.flightDetailTableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! CustomFlightDetailTableViewCell
                
                let flightDict = flightDetail[indexPath.section].dictionary
                let flights = flightDict!["flights"]?.array
                let flightData = flights![indexPath.row].dictionary
                let flightBasic = flightData!["basic_class"]!.dictionary
                let flightFlex = flightData!["flex_class"]!.dictionary
                
                cell.flightNumber.text = String(format: "FLIGHT NO. FY %@", flightData!["flight_number"]!.string!)
                cell.departureAirportLbl.text = String(format: "%@ Airport", flightDict!["departure_station_name"]!.string!)
                cell.arrivalAirportLbl.text = String(format: "%@ Airport", flightDict!["arrival_station_name"]!.string!)
                cell.departureTimeLbl.text = flightData!["departure_time"]!.string
                cell.arrivalTimeLbl.text = flightData!["arrival_time"]!.string
                cell.checkFlight.tag = indexPath.row
                
                if (planGoing == 1 && indexPath.section == 0) || (planReturn == 4 && indexPath.section == 1){
                    cell.priceLbl.text = String(format: "%.2f MYR", (flightBasic!["total_fare"]?.floatValue)!)
                    cell.checkFlight.hidden = false
                    flightAvailable = true
                }else{
                    
                    if flightFlex!["status"]!.string == "sold out"{
                        cell.priceLbl.text = "SOLD OUT"
                        cell.checkFlight.hidden = true
                        cell.checkFlight.checkState = M13CheckboxStateUnchecked
                        flightAvailable = false
                        
                    }else{
                        cell.priceLbl.text = String(format: "%.2f MYR", (flightFlex!["total_fare"]?.floatValue)!)
                        cell.checkFlight.hidden = false
                    }
                    
                }
                
                if indexPath.section == 1{
                    cell.flightIcon.image = UIImage(named: "arrival_icon")
                    cell.checkFlight.userInteractionEnabled = false
                    if NSNumber.init(integer: indexPath.row) == selectedReturnFlight{
                        selectedReturnFlight = NSNumber.init(integer: indexPath.row)
                        cell.checkFlight.checkState = M13CheckboxStateChecked
                    }else{
                        cell.checkFlight.checkState = M13CheckboxStateUnchecked
                    }
                }else{
                    cell.flightIcon.image = UIImage(named: "departure_icon")
                    cell.checkFlight.userInteractionEnabled = false
                    if NSNumber.init(integer: indexPath.row) == selectedGoingFlight{
                        selectedGoingFlight = NSNumber.init(integer: indexPath.row)
                        cell.checkFlight.checkState = M13CheckboxStateChecked
                    }else{
                        cell.checkFlight.checkState = M13CheckboxStateUnchecked
                    }
                }
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if flightDetail.count == 0{
            return 0
        }else{
            return 118
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if flightDetail.count == 0{
            return nil
        }else{
            let flightHeader = NSBundle.mainBundle().loadNibNamed("FlightHeader", owner: self, options: nil)[0] as! FlightHeaderView
            
            flightHeader.frame = CGRectMake(0, 0,self.view.frame.size.width, 118)
            
            let flightDict = flightDetail[section].dictionary
            
            if (planGoing == 1 && section == 0) || (planReturn == 4 && section == 1){
                flightHeader.basicBtn.backgroundColor = UIColor.whiteColor()
                flightHeader.premierBtn.backgroundColor = UIColor.lightGrayColor()
            }else if (planGoing == 2 && section == 0) || (planReturn == 5 && section == 1){
                flightHeader.basicBtn.backgroundColor = UIColor.lightGrayColor()
                flightHeader.premierBtn.backgroundColor = UIColor.whiteColor()
            }
            
            flightHeader.destinationLbl.text = String(format: "%@ - %@", (flightDict!["departure_station_name"]?.string)!,flightDict!["arrival_station_name"]!.string!) //"PENANG - SUBANG"
            flightHeader.wayLbl.text = String(format: "(%@)", flightDict!["type"]!.string!)// "(Return Flight)"
            flightHeader.dateLbl.text = String(format: "%@", flightDict!["departure_date"]!.string!) //"26 JAN 2015"
            
            flightHeader.basicBtn.addTarget(self, action: "changePlan:", forControlEvents: .TouchUpInside)
            if section == 0 {
                flightHeader.basicBtn.tag = section+1
                flightHeader.premierBtn.tag = section+2
            }else{
                flightHeader.basicBtn.tag = section+3
                flightHeader.premierBtn.tag = section+4
            }
            
            flightHeader.premierBtn.addTarget(self, action: "changePlan:", forControlEvents: .TouchUpInside)
        
        
            return flightHeader
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1{
            selectedReturnFlight = NSNumber(integer: indexPath.row)
            self.flightDetailTableView.reloadData()
            isReturnSelected = true
        }else{
            selectedGoingFlight = NSNumber(integer: indexPath.row)
            self.flightDetailTableView.reloadData()
            isGoingSelected = true
        }
    }
    
    func changePlan(sender:UIButton){
        
        let buttonTouch = sender
        print(buttonTouch.tag)
        
        if buttonTouch.tag == 1 || buttonTouch.tag == 2{
            planGoing = buttonTouch.tag
        }else{
            planReturn = buttonTouch.tag
        }
        
        self.flightDetailTableView.reloadData()
        
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
        
        
        var parameters:[String:AnyObject] = [String:AnyObject]()
        
        if !isGoingSelected{
            self.showToastMessage("Please select Going Flight")
        }else if !isReturnSelected && defaults.objectForKey("type")! as! NSNumber != 0{
            self.showToastMessage("Please select Return Flight")
        }else if planGo == "flex_class" && flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["status"].string == "sold out"{
            self.showToastMessage("Please select Going Flight")
        }else{
            
            if defaults.objectForKey("type") as! Int == 1{
                
                let dateReturn = flightDetail[1]["departure_date"].string!
                var dateReturnArr = dateReturn.componentsSeparatedByString(" ")
                
                if planReturn == 4{
                    planBack = "basic_class"
                }else{
                    planBack = "flex_class"
                }
                
                if planBack == "flex_class" && flightDetail[1]["flights"][selectedGoingFlight.integerValue][planGo]["status"].string == "sold out"{
                    
                    self.showToastMessage("Please select Return Flight")
                    
                }else{
                    
                    parameters.updateValue(defaults.objectForKey("type")!, forKey: "type")
                    
                    if userInfo["username"] != nil{
                        parameters.updateValue(userInfo["username"]!, forKey: "username")
                    }else{
                        parameters.updateValue("", forKey: "username")
                    }
                    
                    parameters.updateValue(flightDetail[0]["departure_station_code"].string!, forKey: "departure_station")
                    parameters.updateValue(flightDetail[0]["arrival_station_code"].string!, forKey: "arrival_station")
                    parameters.updateValue(formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])")), forKey: "departure_date")
                    parameters.updateValue(defaults.objectForKey("adult")!, forKey: "adult")
                    parameters.updateValue(defaults.objectForKey("infant")!, forKey: "infant")
                    parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue]["flight_number"].string!, forKey: "flight_number_1")
                    parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue]["departure_time"].string!, forKey: "departure_time_1")
                    parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue]["arrival_time"].string!, forKey: "arrival_time_1")
                    parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue]["journey_sell_key"].string!, forKey: "journey_sell_key_1")
                    parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["fare_sell_key"].string!, forKey: "fare_sell_key_1")
                    parameters.updateValue(formatDate(stringToDate("\(dateReturnArr[2])-\(dateReturnArr[1])-\(dateReturnArr[0])")), forKey: "return_date")
                    parameters.updateValue(flightDetail[1]["flights"][selectedGoingFlight.integerValue]["flight_number"].string!, forKey: "flight_number_2")
                    parameters.updateValue(flightDetail[1]["flights"][selectedGoingFlight.integerValue]["departure_time"].string!, forKey: "departure_time_2")
                    parameters.updateValue(flightDetail[1]["flights"][selectedGoingFlight.integerValue]["arrival_time"].string!, forKey: "arrival_time_2")
                    parameters.updateValue(flightDetail[1]["flights"][selectedGoingFlight.integerValue]["journey_sell_key"].string!, forKey: "journey_sell_key_2")
                    parameters.updateValue(flightDetail[1]["flights"][selectedGoingFlight.integerValue][planBack]["fare_sell_key"].string!, forKey: "fare_sell_key_2")
                    
                    let manager = WSDLNetworkManager()
                    showHud()
                    manager.sharedClient().createRequestWithService("selectFlight", withParams: parameters) { (result) -> Void in
                        self.hideHud()
                        
                        self.showToastMessage(result["status"].string!)
                        defaults.setObject(result["booking_id"].int , forKey: "booking_id")
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let personalDetailVC = storyboard.instantiateViewControllerWithIdentifier("PassengerDetailVC") as! AddPassengerDetailViewController
                        self.navigationController!.pushViewController(personalDetailVC, animated: true)
                        
                    }
                    
                }
                
            }else{
                
                parameters.updateValue(defaults.objectForKey("type")!, forKey: "type")
                if userInfo["username"] != nil{
                    parameters.updateValue(userInfo["username"]!, forKey: "username")
                }else{
                    parameters.updateValue("", forKey: "username")
                }
                parameters.updateValue(flightDetail[0]["departure_station_code"].string!, forKey: "departure_station")
                parameters.updateValue(flightDetail[0]["arrival_station_code"].string!, forKey: "arrival_station")
                parameters.updateValue(formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])")), forKey: "departure_date")
                parameters.updateValue(defaults.objectForKey("adult")!, forKey: "adult")
                parameters.updateValue(defaults.objectForKey("infant")!, forKey: "infant")
                parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue]["flight_number"].string!, forKey: "flight_number_1")
                parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue]["departure_time"].string!, forKey: "departure_time_1")
                parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue]["arrival_time"].string!, forKey: "arrival_time_1")
                parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue]["journey_sell_key"].string!, forKey: "journey_sell_key_1")
                parameters.updateValue(flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["fare_sell_key"].string!, forKey: "fare_sell_key_1")
                parameters.updateValue("", forKey: "return_date")
                parameters.updateValue("", forKey: "flight_number_2")
                parameters.updateValue("", forKey: "departure_time_2")
                parameters.updateValue("", forKey: "arrival_time_2")
                parameters.updateValue("", forKey: "journey_sell_key_2")
                parameters.updateValue("", forKey: "fare_sell_key_2")
                
                let manager = WSDLNetworkManager()
                showHud()
                manager.sharedClient().createRequestWithService("selectFlight", withParams: parameters) { (result) -> Void in
                    self.hideHud()
                    
                    self.showToastMessage(result["status"].string!)
                    defaults.setObject(result["booking_id"].int , forKey: "booking_id")
                    print(result["booking_id"].int)
                    let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                    let personalDetailVC = storyboard.instantiateViewControllerWithIdentifier("PassengerDetailVC") as! AddPassengerDetailViewController
                    self.navigationController!.pushViewController(personalDetailVC, animated: true)
                    
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
