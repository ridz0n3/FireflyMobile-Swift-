//
//  EditMHFlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/3/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox
import SwiftyJSON

class EditMHFlightDetailViewController: CommonMHFlightDetailViewController {

    var goingData = NSDictionary()
    var returnData = NSDictionary()
    var signature = String()
    var type = Int()
    var bookId = String()
    var pnr = String()
    
    var username = String()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkGoingIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        checkReturnIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let flightDict = flightDetail[indexPath.section].dictionary
        
        if flightDict!["flights"]?.count == 0 {
            return 107
        }else{
            
            if indexPath.section == 0{
                if goingData["status"] as! String == "N"{
                    return 107
                }else{
                    return 222
                }
            }else{
                if returnData["status"] as! String == "N"{
                    return 107
                }else{
                    return 222
                }
            }
            
            
        }
        
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
            }else {
                let cell = self.flightDetailTableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! CustomMHFlightDetailTableViewCell
                
                let flights = flightDict!["flights"]?.array
                let flightData = flights![indexPath.row].dictionary
                
                let economyPromo = flightData!["economy_promo_class"]!.dictionary
                let economy = flightData!["economy_class"]!.dictionary
                let business = flightData!["business_class"]!.dictionary
                
                cell.flightNumber.text = String(format: "FLIGHT NO. MH %@", flightData!["flight_number"]!.string!)
                cell.departureAirportLbl.text = "\(flightDict!["departure_station_name"]!.stringValue)"
                cell.arrivalAirportLbl.text = "\(flightDict!["arrival_station_name"]!.stringValue)"
                cell.departureTimeLbl.text = flightData!["departure_time"]!.string
                cell.arrivalTimeLbl.text = flightData!["arrival_time"]!.string
                
                if economyPromo!["status"]?.string == "sold out"{
                    cell.economyPromoSoldView.hidden = false
                    cell.economyPromoNotAvailableView.hidden = true
                    cell.economyPromoBtn.hidden = true
                }else if economyPromo!["status"]?.string == "Not Available"{
                    cell.economyPromoSoldView.hidden = true
                    cell.economyPromoNotAvailableView.hidden = false
                    cell.economyPromoBtn.hidden = true
                }else{
                    cell.economyPromoNotAvailableView.hidden = true
                    cell.economyPromoSoldView.hidden = true
                    cell.economyPromoPriceLbl.text = String(format: "%.2f MYR", economyPromo!["fare_price"]!.floatValue)
                    
                    cell.economyPromoBtn.hidden = false
                    
                    cell.economyPromoBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:1"
                    cell.economyPromoBtn.addTarget(self, action: "checkCategory:", forControlEvents: .TouchUpInside)
                    
                }
                
                if economy!["status"]?.string == "sold out"{
                    cell.economySoldView.hidden = false
                    cell.economyNotAvailableView.hidden = true
                    cell.economyBtn.hidden = true
                }else if economy!["status"]?.string == "Not Available"{
                    cell.economySoldView.hidden = true
                    cell.economyNotAvailableView.hidden = false
                    cell.economyBtn.hidden = true
                }else{
                    cell.economyNotAvailableView.hidden = true
                    cell.economySoldView.hidden = true
                    cell.economyPriceLbl.text = String(format: "%.2f MYR", economy!["fare_price"]!.floatValue)
                    
                    cell.economyBtn.hidden = false
                    
                    cell.economyBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:2"
                    cell.economyBtn.addTarget(self, action: "checkCategory:", forControlEvents: .TouchUpInside)
                }
                
                if business!["status"]?.string == "sold out"{
                    cell.businessSoldView.hidden = false
                    cell.businessNotAvailableView.hidden = true
                    cell.businessBtn.hidden = true
                }else if business!["status"]?.string == "Not Available"{
                    cell.businessSoldView.hidden = true
                    cell.businessNotAvailableView.hidden = false
                    cell.businessBtn.hidden = true
                }else{
                    cell.businessNotAvailableView.hidden = true
                    cell.businessSoldView.hidden = true
                    cell.businessPriceLbl.text = String(format: "%.2f MYR", business!["fare_price"]!.floatValue)
                    cell.businessBtn.hidden = false
                    
                    cell.businessBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:3"
                    cell.businessBtn.addTarget(self, action: "checkCategory:", forControlEvents: .TouchUpInside)
                }

                if indexPath.section == 1{
                    cell.flightIcon.image = UIImage(named: "arrival_icon")
                    if checkReturnIndexPath.section == 1{
                        if checkReturnIndexPath.row == indexPath.row{
                            if checkReturnIndex == "1"{
                                cell.economyPromoCheckBox.checkState = .Checked
                            }else if checkReturnIndex == "2"{
                                cell.economyCheckBox.checkState = .Checked
                            }else if checkReturnIndex == "3"{
                                cell.businessCheckBox.checkState = .Checked
                            }
                        }else{
                            cell.economyPromoCheckBox.checkState = .Unchecked
                            cell.economyCheckBox.checkState = .Unchecked
                            cell.businessCheckBox.checkState = .Unchecked
                        }
                    }else{
                        cell.economyPromoCheckBox.checkState = .Unchecked
                        cell.economyCheckBox.checkState = .Unchecked
                        cell.businessCheckBox.checkState = .Unchecked
                    }
                }else{
                    cell.flightIcon.image = UIImage(named: "departure_icon")
                    if checkGoingIndexPath.section == 0{
                        if checkGoingIndexPath.row == indexPath.row{
                            if checkGoingIndex == "1"{
                                cell.economyPromoCheckBox.checkState = .Checked
                            }else if checkGoingIndex == "2"{
                                cell.economyCheckBox.checkState = .Checked
                            }else if checkGoingIndex == "3"{
                                cell.businessCheckBox.checkState = .Checked
                            }
                        }else{
                            cell.economyPromoCheckBox.checkState = .Unchecked
                            cell.economyCheckBox.checkState = .Unchecked
                            cell.businessCheckBox.checkState = .Unchecked
                        }
                    }else{
                        cell.economyPromoCheckBox.checkState = .Unchecked
                        cell.economyCheckBox.checkState = .Unchecked
                        cell.businessCheckBox.checkState = .Unchecked
                    }
                }
                return cell
            }
        }
    }

    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        var planGo = String()
        var planBack = String()
        
        let date = flightDetail[0]["departure_date"].string!
        var dateArr = date.componentsSeparatedByString(" ")
        var isReturn = Bool()
        
        if flightDetail.count == 2{
            isReturn = true
        }
        
        if checkGoingIndex == "" && goingData["status"] as! String == "Y"{
            showErrorMessage("LabelErrorGoingFlight".localized)
        }else if isReturn && checkReturnIndex == ""  && returnData["status"] as! String == "Y"{
            showErrorMessage("LabelErrorReturnFlight".localized)
        }else{
            
            if type == 1{
                let dateReturn = flightDetail[1]["departure_date"].string!
                var dateReturnArr = dateReturn.componentsSeparatedByString(" ")
                
                if checkReturnIndex == "1"{
                    planBack = "economy_promo_class"
                }else if checkReturnIndex == "2"{
                    planBack = "economy_class"
                }else{
                    planBack = "business_class"
                }
                
                status_2 = returnData["status"] as! String
                return_date = formatDate(stringToDate("\(dateReturnArr[2])-\(dateReturnArr[1])-\(dateReturnArr[0])"))
                
                if status_2 == "Y"{
                    flight_number_2 = flightDetail[1]["flights"][checkReturnIndexPath.row]["flight_number"].string!
                    departure_time_2 = flightDetail[1]["flights"][checkReturnIndexPath.row]["departure_time"].string!
                    arrival_time_2 = flightDetail[1]["flights"][checkReturnIndexPath.row]["arrival_time"].string!
                    journey_sell_key_2 = flightDetail[1]["flights"][checkReturnIndexPath.row]["journey_sell_key"].string!
                    fare_sell_key_2 = flightDetail[1]["flights"][checkReturnIndexPath.row][planBack]["fare_sell_key"].string!
                }else{
                    flight_number_2 = "none"
                    departure_time_2 = "none"
                    arrival_time_2 = "none"
                    journey_sell_key_2 = "none"
                    fare_sell_key_2 = "none"
                }
                
            }
            
            if checkGoingIndex == "1"{
                planGo = "economy_promo_class"
            }else if checkGoingIndex == "2"{
                planGo = "economy_class"
            }else{
                planGo = "business_class"
            }
            
            status_1 = goingData["status"] as! String
            departure_station = flightDetail[0]["departure_station_code"].string!
            arrival_station = flightDetail[0]["arrival_station_code"].string!
            departure_date = formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"))
            
            if status_1 == "Y"{
                flight_number_1 = flightDetail[0]["flights"][checkGoingIndexPath.row]["flight_number"].string!
                departure_time_1 = flightDetail[0]["flights"][checkGoingIndexPath.row]["departure_time"].string!
                arrival_time_1 = flightDetail[0]["flights"][checkGoingIndexPath.row]["arrival_time"].string!
                journey_sell_key_1 = flightDetail[0]["flights"][checkGoingIndexPath.row]["journey_sell_key"].string!
                fare_sell_key_1 = flightDetail[0]["flights"][checkGoingIndexPath.row][planGo]["fare_sell_key"].string!
            }else{
                flight_number_1 = "none"
                departure_time_1 = "none"
                arrival_time_1 = "none"
                journey_sell_key_1 = "none"
                fare_sell_key_1 = "none"
            }
            
            sentData()
            
        }
        
    }
    
    func sentData(){
        showLoading() 
        FireFlyProvider.request(.SelectChangeFlight(pnr, bookId, signature, type, departure_date, arrival_time_1, departure_time_1, fare_sell_key_1, flight_number_1, journey_sell_key_1, status_1, return_date, arrival_time_2, departure_time_2, fare_sell_key_2, flight_number_2, journey_sell_key_2, status_2, departure_station, arrival_station), completion: { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    
                    
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                        manageFlightVC.isConfirm = true
                        manageFlightVC.itineraryData = json.object as! NSDictionary
                        self.navigationController!.pushViewController(manageFlightVC, animated: true)
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
            
        })    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
