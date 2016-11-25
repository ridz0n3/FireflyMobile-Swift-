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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.editFlightDetailScreen)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if flightDetail.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoFlightCell", for: indexPath)
            return cell
        }else{
            let flightDict = flightDetail[indexPath.section].dictionary
            
            if indexPath.section == 0 && goingData["status"] as! String == "N"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoSelectCell", for: indexPath)
                return cell
            }else if indexPath.section == 1 && returnData["status"] as! String == "N"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoSelectCell", for: indexPath)
                return cell
            }else if flightDict!["flights"]?.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoFlightCell", for: indexPath)
                return cell
            }else{
                
                let cell = self.flightDetailTableView.dequeueReusableCell(withIdentifier: "flightCell", for: indexPath) as! CustomFlightDetailTableViewCell
                
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
                        cell.checkFlight.isHidden = true
                        cell.checkFlight.checkState = M13CheckboxState.unchecked
                        flightAvailable = false
                        
                    }else{
                        if flightBasic!["discount"]?.floatValue == 0{
                            cell.priceLbl.text = String(format: "%.2f MYR", (flightBasic!["total_fare"]?.floatValue)!)
                            cell.checkFlight.isHidden = false
                            cell.strikeDegree.isHidden = true
                            cell.promoPriceLbl.isHidden = true
                            flightAvailable = true
                        }else{
                            cell.promoPriceLbl.text = String(format: "%.2f MYR", (flightBasic!["total_fare"]?.floatValue)!)
                            cell.priceLbl.text = String(format: "%.2f MYR", (flightBasic!["before_discount_fare"]?.floatValue)!)
                            cell.strikeDegree.isHidden = false
                            cell.checkFlight.isHidden = false
                            flightAvailable = true
                        }
                    }
                }else{
                    
                    if flightFlex!["status"]!.string == "sold out"{
                        cell.priceLbl.text = "SOLD OUT"
                        cell.checkFlight.isHidden = true
                        cell.checkFlight.checkState = M13CheckboxState.unchecked
                        flightAvailable = false
                        
                    }else{
                        cell.priceLbl.text = String(format: "%.2f MYR", (flightFlex!["total_fare"]?.floatValue)!)
                        cell.checkFlight.isHidden = false
                    }
                    
                }
                
                cell.checkFlight.strokeColor = UIColor.orange
                cell.checkFlight.checkColor = UIColor.orange
                if indexPath.section == 1{
                    cell.flightIcon.image = UIImage(named: "arrival_icon")
                    cell.checkFlight.isUserInteractionEnabled = false
                    if NSNumber.init(value: indexPath.row) == selectedReturnFlight{
                        selectedReturnFlight = NSNumber.init(value: indexPath.row)
                        cell.checkFlight.checkState = M13CheckboxState.checked
                    }else{
                        cell.checkFlight.checkState = M13CheckboxState.unchecked
                    }
                }else{
                    cell.flightIcon.image = UIImage(named: "departure_icon")
                    cell.checkFlight.isUserInteractionEnabled = false
                    if NSNumber.init(value: indexPath.row) == selectedGoingFlight{
                        selectedGoingFlight = NSNumber.init(value: indexPath.row)
                        cell.checkFlight.checkState = M13CheckboxState.checked
                    }else{
                        cell.checkFlight.checkState = M13CheckboxState.unchecked
                    }
                }
                return cell
            }
        }
    }
    
    @IBAction func ContinueBtnPressed(_ sender: AnyObject) {
        
        let date = flightDetail[0]["departure_date"].string!
        var dateArr = date.components(separatedBy: " ")
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
        }else if planGo == "flex_class" && flightDetail[0]["flights"][selectedGoingFlight.intValue][planGo]["status"].string == "sold out" && goingData["status"] as! String == "Y"{
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
                var dateReturnArr = dateReturn.components(separatedBy: " ")
                
                if planReturn == 4{
                    planBack = "basic_class"
                }else{
                    planBack = "flex_class"
                }
                
                if planBack == "flex_class" && flightDetail[1]["flights"][selectedReturnFlight.intValue][planBack]["status"].string == "sold out" && returnData["status"] as! String == "Y"{
                    showErrorMessage("LabelErrorReturnFlight".localized)
                    isError = true
                }else{
                    
                    return_date = formatDate(stringToDate("\(dateReturnArr[2])-\(dateReturnArr[1])-\(dateReturnArr[0])"))
                    status_2 = returnData["status"] as! String
                    
                    if status_2 == "Y"{
                        
                        flight_number_2 = flightDetail[1]["flights"][selectedReturnFlight.intValue]["flight_number"].string!
                        departure_time_2 = flightDetail[1]["flights"][selectedReturnFlight.intValue]["departure_time"].string!
                        arrival_time_2 = flightDetail[1]["flights"][selectedReturnFlight.intValue]["arrival_time"].string!
                        journey_sell_key_2 = flightDetail[1]["flights"][selectedReturnFlight.intValue]["journey_sell_key"].string!
                        fare_sell_key_2 = flightDetail[1]["flights"][selectedReturnFlight.intValue][planBack]["fare_sell_key"].string!
                        
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
                    flight_number_1 = flightDetail[0]["flights"][selectedGoingFlight.intValue]["flight_number"].string!
                    departure_time_1 = flightDetail[0]["flights"][selectedGoingFlight.intValue]["departure_time"].string!
                    arrival_time_1 = flightDetail[0]["flights"][selectedGoingFlight.intValue]["arrival_time"].string!
                    journey_sell_key_1 = flightDetail[0]["flights"][selectedGoingFlight.intValue]["journey_sell_key"].string!
                    fare_sell_key_1 = flightDetail[0]["flights"][selectedGoingFlight.intValue][planGo]["fare_sell_key"].string!
                }else{
                    flight_number_1 = "none"
                    departure_time_1 = "none"
                    arrival_time_1 = "none"
                    journey_sell_key_1 = "none"
                    fare_sell_key_1 = "none"
                }
                
                
                showLoading() 
                FireFlyProvider.request(.SelectChangeFlight(pnr, bookId, signature, type, departure_date, arrival_time_1, departure_time_1, fare_sell_key_1, flight_number_1, journey_sell_key_1, status_1, return_date, arrival_time_2, departure_time_2, fare_sell_key_2, flight_number_2, journey_sell_key_2, status_2, departure_station, arrival_station), completion: { (result) -> () in
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                let manageFlightVC = storyboard.instantiateViewController(withIdentifier: "ManageFlightMenuVC") as! ManageFlightHomeViewController
                                manageFlightVC.isConfirm = true
                                manageFlightVC.itineraryData = json.object as! NSDictionary
                                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            }else if json["status"] == "error"{
                                
                                showErrorMessage(json["message"].string!)
                            }else if json["status"].string == "401"{
                                hideLoading()
                                showErrorMessage(json["message"].string!)
                                InitialLoadManager.sharedInstance.load()
                                
                                for views in (self.navigationController?.viewControllers)!{
                                    if views.classForCoder == HomeViewController.classForCoder(){
                                        _ = self.navigationController?.popToViewController(views, animated: true)
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
