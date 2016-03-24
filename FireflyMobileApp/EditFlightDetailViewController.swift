//
//  EditFlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/25/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import M13Checkbox

class EditFlightDetailViewController: CommonFlightDetailViewController {
    
    var goingData = NSDictionary()
    var returnData = NSDictionary()
    var signature = String()
    var type = Int()
    var bookId = String()
    var pnr = String()
    
    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if flightDetail.count == 0{
            return 1
        }else{
            
            let flightDict = flightDetail[section].dictionary
            
            if section == 0{
                
                if flightDict!["flights"]?.count == 0 || goingData["status"] as! String == "N"{
                    return 1
                }else{
                    return (flightDict!["flights"]?.count)!
                }
                
            }else{
                
                if flightDict!["flights"]?.count == 0 || returnData["status"] as! String == "N"{
                    return 1
                }else{
                    return (flightDict!["flights"]?.count)!
                }
                
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if flightDetail.count == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("NoFlightCell", forIndexPath: indexPath)
            return cell
        }else{
            let flightDict = flightDetail[indexPath.section].dictionary
            
            if indexPath.section == 0 && goingData["status"] as! String == "N"{
                let cell = tableView.dequeueReusableCellWithIdentifier("NoSelectCell", forIndexPath: indexPath)
                return cell
            }else if indexPath.section == 1 && returnData["status"] as! String == "N"{
                let cell = tableView.dequeueReusableCellWithIdentifier("NoSelectCell", forIndexPath: indexPath)
                return cell
            }else if flightDict!["flights"]?.count == 0{
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
                cell.departureAirportLbl.text = "\(flightDict!["departure_station_name"]!.stringValue)"
                cell.arrivalAirportLbl.text = "\(flightDict!["arrival_station_name"]!.stringValue)"
                cell.departureTimeLbl.text = flightData!["departure_time"]!.string
                cell.arrivalTimeLbl.text = flightData!["arrival_time"]!.string
                cell.checkFlight.tag = indexPath.row
                
                if (planGoing == 1 && indexPath.section == 0) || (planReturn == 4 && indexPath.section == 1){
                    
                    if flightBasic!["status"]!.string == "sold out"{
                        cell.priceLbl.text = "SOLD OUT"
                        cell.checkFlight.hidden = true
                        cell.checkFlight.checkState = M13CheckboxState.Unchecked
                        flightAvailable = false
                        
                    }else{
                        if flightBasic!["discount"]?.floatValue == 0{
                            cell.priceLbl.text = String(format: "%.2f MYR", (flightBasic!["total_fare"]?.floatValue)!)
                            cell.checkFlight.hidden = true
                            cell.strikeDegree.hidden = true
                            flightAvailable = true
                        }else{
                            cell.promoPriceLbl.text = String(format: "%.2f MYR", (flightBasic!["total_fare"]?.floatValue)!)
                            cell.priceLbl.text = String(format: "%.2f MYR", (flightBasic!["before_discount_fare"]?.floatValue)!)
                            cell.strikeDegree.hidden = false
                            cell.checkFlight.hidden = false
                            flightAvailable = true
                        }
                    }
                }else{
                    
                    if flightFlex!["status"]!.string == "sold out"{
                        cell.priceLbl.text = "SOLD OUT"
                        cell.checkFlight.hidden = true
                        cell.checkFlight.checkState = M13CheckboxState.Unchecked
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
                        cell.checkFlight.checkState = M13CheckboxState.Checked
                    }else{
                        cell.checkFlight.checkState = M13CheckboxState.Unchecked
                    }
                }else{
                    cell.flightIcon.image = UIImage(named: "departure_icon")
                    cell.checkFlight.userInteractionEnabled = false
                    if NSNumber.init(integer: indexPath.row) == selectedGoingFlight{
                        selectedGoingFlight = NSNumber.init(integer: indexPath.row)
                        cell.checkFlight.checkState = M13CheckboxState.Checked
                    }else{
                        cell.checkFlight.checkState = M13CheckboxState.Unchecked
                    }
                }
                return cell
            }
        }
    }
    
    @IBAction func ContinueBtnPressed(sender: AnyObject) {
        
        let date = flightDetail[0]["departure_date"].string!
        var dateArr = date.componentsSeparatedByString(" ")
        var planGo = String()
        var planBack = String()
        
        if planGoing == 1{
            planGo = "basic_class"
        }else{
            planGo = "flex_class"
        }
        
        if !isGoingSelected && goingData["status"] as! String == "Y"{
            showErrorMessage("LabelErrorGoingFlight".localized)
        }else if !isReturnSelected && type == 1 && returnData["status"] as! String == "Y"{
            showErrorMessage("LabelErrorReturnFlight".localized)
        }else if planGo == "flex_class" && flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["status"].string == "sold out" && goingData["status"] as! String == "Y"{
            showErrorMessage("LabelErrorGoingFlight".localized)
        }else{
            var isType1 = false
            var isError = false
            
            var departure_station = String()
            var arrival_station = String()
            var departure_date = String()
            var arrival_time_1 = String()
            var departure_time_1 = String()
            var fare_sell_key_1 = String()
            var flight_number_1 = String()
            var journey_sell_key_1 = String()
            var status_1 = String()
            
            var return_date = String()
            var arrival_time_2 = String()
            var departure_time_2 = String()
            var fare_sell_key_2 = String()
            var flight_number_2 = String()
            var journey_sell_key_2 = String()
            var status_2 = String()
            
            if type == 1{
                let dateReturn = flightDetail[1]["departure_date"].string!
                var dateReturnArr = dateReturn.componentsSeparatedByString(" ")
                
                if planReturn == 4{
                    planBack = "basic_class"
                }else{
                    planBack = "flex_class"
                }
                
                if planBack == "flex_class" && flightDetail[1]["flights"][selectedReturnFlight.integerValue][planBack]["status"].string == "sold out" && returnData["status"] as! String == "Y"{
                    showErrorMessage("LabelErrorReturnFlight".localized)
                    isError = true
                }else{
                    
                    return_date = formatDate(stringToDate("\(dateReturnArr[2])-\(dateReturnArr[1])-\(dateReturnArr[0])"))
                    status_2 = returnData["status"] as! String
                    
                    if status_2 == "Y"{
                        
                        flight_number_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue]["flight_number"].string!
                        departure_time_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue]["departure_time"].string!
                        arrival_time_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue]["arrival_time"].string!
                        journey_sell_key_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue]["journey_sell_key"].string!
                        fare_sell_key_2 = flightDetail[1]["flights"][selectedReturnFlight.integerValue][planBack]["fare_sell_key"].string!
                        
                    }else{
                        
                        flight_number_2 = "none"
                        departure_time_2 = "none"
                        arrival_time_2 = "none"
                        journey_sell_key_2 = "none"
                        fare_sell_key_2 = "none"
                        
                    }
                    
                }
                isType1 = true
            }
            
            if (isType1 == true && isError == false) || isType1 == false{
                
                departure_station = flightDetail[0]["departure_station_code"].string!
                arrival_station = flightDetail[0]["arrival_station_code"].string!
                
                departure_date = formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"))
                status_1 = goingData["status"] as! String
                
                if status_1 == "Y"{
                    flight_number_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["flight_number"].string!
                    departure_time_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["departure_time"].string!
                    arrival_time_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["arrival_time"].string!
                    journey_sell_key_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue]["journey_sell_key"].string!
                    fare_sell_key_1 = flightDetail[0]["flights"][selectedGoingFlight.integerValue][planGo]["fare_sell_key"].string!
                }else{
                    flight_number_1 = "none"
                    departure_time_1 = "none"
                    arrival_time_1 = "none"
                    journey_sell_key_1 = "none"
                    fare_sell_key_1 = "none"
                }
                
                
                showLoading(self) //showHud("open")
                FireFlyProvider.request(.SelectChangeFlight(pnr, bookId, signature, type, departure_date, arrival_time_1, departure_time_1, fare_sell_key_1, flight_number_1, journey_sell_key_1, status_1, return_date, arrival_time_2, departure_time_2, fare_sell_key_2, flight_number_2, journey_sell_key_2, status_2, departure_station, arrival_station), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            //showHud("close")
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                                manageFlightVC.isConfirm = true
                                manageFlightVC.itineraryData = json.object as! NSDictionary
                                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            }else if json["status"] == "error"{
                                //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                            }
                            hideLoading(self)
                        }
                        catch {
                            
                        }
                        
                    case .Failure(let failureResult):
                        //showHud("close")
                        hideLoading(self)
                        showErrorMessage(failureResult.nsError.localizedDescription)
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
