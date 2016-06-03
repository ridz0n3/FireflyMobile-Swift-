//
//  EditSeatSelectionViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/19/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditSeatSelectionViewController: CommonSeatSelectionViewController {
    
    var bookId = String()
    var signature = String()
    var pnr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.editSeatSelectionScreen)
        var newSeat = [Dictionary<String,AnyObject>]()
        var seatArray = [Dictionary<String,AnyObject>]()
        var seatData = [Dictionary<String,AnyObject>]()
        var passengersArr = [[Dictionary<String,AnyObject>]]()
        var countJourney = 0
        for info in journeys as! [Dictionary<String, AnyObject>]{
            
            var data = Dictionary<String,AnyObject>()
            let departureStationName = info["departure_station_name"] as! String
            let departureStation =  info["departure_station"] as! String
            let arrivalStation = info["arrival_station"] as! String
            let arrivalStationName = info["arrival_station_name"] as! String
            let passengerInfo = info["passengers"] as! [Dictionary<String,AnyObject>]
            let seat = NSMutableArray()
            seatData = info["seat_info"] as! [Dictionary<String,AnyObject>]
            newSeat = seatData
            var seatIndex = 0
            
            while newSeat.count != 0{
                if seatIndex == 3{
                    
                    seatIndex = 0
                    seatArray.append(newSeat[0])
                    seat.addObject(seatArray)
                    newSeat.removeAtIndex(0)
                    seatArray = [Dictionary<String,AnyObject>]()
                    
                }else{
                    
                    seatArray.append(newSeat[0])
                    newSeat.removeAtIndex(0)
                    seatIndex += 1
                    
                }
            }
            
            var i = 0
            
            for seatInfo in passengerInfo{
                
                for seatRowInfo in seat{
                    
                    for tempInfo in seatRowInfo as! [Dictionary<String,AnyObject>]{
                        
                        if seatInfo["unit_designator"] as! String == tempInfo["seat_number"] as! String{
                            if countJourney == 0{
                                passengers1.updateValue(tempInfo as NSDictionary, forKey: "\(i)")
                                seatDict.updateValue(passengers1, forKey: "\(countJourney)")
                                
                                seatType1.updateValue(tempInfo["seat_type"] as! String, forKey: "\(i)")
                                seatTypeDict.updateValue(seatType1, forKey: "\(countJourney)")
                            }else{
                                passengers2.updateValue(tempInfo as NSDictionary, forKey: "\(i)")
                                seatDict.updateValue(passengers2, forKey: "\(countJourney)")
                                
                                seatType2.updateValue(tempInfo["seat_type"] as! String, forKey: "\(i)")
                                seatTypeDict.updateValue(seatType2, forKey: "\(countJourney)")
                                //seatTypeDict.updateValue(tempInfo["seat_type"] as! String, forKey: "\(countJourney)")
                            }
                            break
                        }
                        
                    }
                    
                }
                i += 1
                
            }
            
            passengersArr.append(passengerInfo)
            
            data["departure_station"] = departureStation
            data["departure_station_name"] = departureStationName
            data["arrival_station"] = arrivalStation
            data["arrival_station_name"] = arrivalStationName
            data["seat_info"] = seat
            
            details.append(data)
            countJourney += 1
            
        }
        
        if isEdit{
            passenger = passengersArr
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.seatTableView.dequeueReusableCellWithIdentifier("PassengerCell", forIndexPath: indexPath) as! CustomSeatSelectionTableViewCell
            
            var passengerDetail = Dictionary<String, AnyObject>()
            
            if isEdit{
                let passengerDetailArray = passenger[0] as! [Dictionary<String, AnyObject>]
                passengerDetail = passengerDetailArray[indexPath.row]
            }else{
                passengerDetail = passenger[indexPath.row] as! Dictionary<String, AnyObject>
            }
            
            let passengerName = "\(passengerDetail["title"]!). \(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            
            if journeys[indexPath.section]["flight_status"] as! String != "departed"{
                
                if passengerDetail["checked_in"] as! String != "Y"{
                    
                    if !isSelect{
                        sectionSelect = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
                        isSelect = true
                    }
                    
                    if (indexPath.section == sectionSelect.section) && (indexPath.row == sectionSelect.row){
                        cell.rowView.backgroundColor = UIColor.yellowColor()
                    }else{
                        cell.rowView.backgroundColor = UIColor.clearColor()
                    }
                    
                    cell.removeSeat.accessibilityHint = "section:\(indexPath.section),row:\(indexPath.row)"
                    cell.removeSeat.addTarget(self, action: #selector(CommonSeatSelectionViewController.removeSeat(_:)), forControlEvents: .TouchUpInside)
                }else{
                    cell.removeSeat.hidden = true
                }
                
            }else{
                
                cell.removeSeat.hidden = true
                
                if details.count == 2 && !selectChange{
                    sectionSelect = NSIndexPath(forRow: 0, inSection: indexPath.section + 1)
                }else if details.count == 1 && !selectChange{
                    sectionSelect = NSIndexPath(forRow: 0, inSection: 90)
                }
            }
            
            if seatDict.count != 0{
                
                if seatDict["\(indexPath.section)"] != nil{
                    
                    let tempSeat = seatDict["\(indexPath.section)"] as! [String:AnyObject]
                    
                    if tempSeat["\(indexPath.row)"] != nil{
                        let data = tempSeat["\(indexPath.row)"] as! NSDictionary
                        cell.seatNumber.text = data["seat_number"] as? String
                        
                    }else{
                        cell.seatNumber.text = ""
                    }
                    
                }else{
                    cell.seatNumber.text = ""
                }
                
            }else{
                cell.seatNumber.text = ""
            }
            
            cell.seatNumber.layer.cornerRadius = 10
            cell.seatNumber.layer.borderWidth = 1
            cell.seatNumber.layer.borderColor = UIColor.blackColor().CGColor
            cell.passengerName.text = passengerName
            
            return cell
        }else if (indexPath.section == 1 && details.count == 2){
            let cell = self.seatTableView.dequeueReusableCellWithIdentifier("PassengerCell", forIndexPath: indexPath) as! CustomSeatSelectionTableViewCell
            
            var passengerDetail = Dictionary<String, AnyObject>()
            
            if isEdit{
                let passengerArray = passenger[1] as! [Dictionary<String, AnyObject>]
                passengerDetail = passengerArray[indexPath.row]
            }else{
                passengerDetail = passenger[indexPath.row] as! Dictionary<String, AnyObject>
            }
            
            let passengerName = "\(passengerDetail["title"]!). \(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            
            if journeys[indexPath.section]["flight_status"] as! String != "departed"{
                
                if passengerDetail["checked_in"] as! String != "Y"{
                    
                    if !isSelect{
                        sectionSelect = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
                        isSelect = true
                    }
                    
                    if (indexPath.section == sectionSelect.section) && (indexPath.row == sectionSelect.row){
                        cell.rowView.backgroundColor = UIColor.yellowColor()
                    }else{
                        cell.rowView.backgroundColor = UIColor.clearColor()
                    }
                    
                    cell.removeSeat.accessibilityHint = "section:\(indexPath.section),row:\(indexPath.row)"
                    cell.removeSeat.addTarget(self, action: #selector(CommonSeatSelectionViewController.removeSeat(_:)), forControlEvents: .TouchUpInside)
                }else{
                    cell.removeSeat.hidden = true
                }
                
            }else{
                cell.removeSeat.hidden = true
                
                if details.count == 2 && !selectChange{
                    sectionSelect = NSIndexPath(forRow: 0, inSection: 90)
                }
            }
            
            if seatDict.count != 0{
                
                if seatDict["\(indexPath.section)"] != nil{
                    if seatDict["\(indexPath.section)"] != nil{
                        
                        let tempSeat = seatDict["\(indexPath.section)"] as! Dictionary<String, AnyObject>
                        
                        if tempSeat["\(indexPath.row)"] != nil{
                            
                            let data = tempSeat["\(indexPath.row)"] as! Dictionary<String, AnyObject>
                            cell.seatNumber.text = data["seat_number"] as? String
                            
                        }else{
                            cell.seatNumber.text = ""
                        }
                        
                    }else{
                        cell.seatNumber.text = ""
                    }
                }else{
                    cell.seatNumber.text = ""
                }
                
                
            }else{
                cell.seatNumber.text = ""
            }
            
            cell.seatNumber.layer.cornerRadius = 10
            cell.seatNumber.layer.borderWidth = 1
            cell.seatNumber.layer.borderColor = UIColor.blackColor().CGColor
            cell.passengerName.text = passengerName
            cell.removeSeat.tag = indexPath.row
            
            
            return cell
        }else{
            
            var cell = CustomSeatSelectionTableViewCell()
            
            if details.count == 2{
                cell = cellConfiguration(indexPath, selectIndex: sectionSelect.section)
            }else{
                cell = cellConfiguration(indexPath, selectIndex: 0)
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if details.count == 2{
            if indexPath.section != 2{
                
                if journeys[indexPath.section]["flight_status"] as! String != "departed"{
                    
                    let passengerInfo = journeys[indexPath.section]["passengers"] as! [AnyObject]
                    let passengerData = passengerInfo[indexPath.row]
                    
                    if passengerData["checked_in"] as! String != "Y"{
                        selectChange = true
                        let cell = self.seatTableView.cellForRowAtIndexPath(indexPath) as! CustomSeatSelectionTableViewCell
                        cell.rowView.backgroundColor = UIColor.yellowColor()
                        sectionSelect = indexPath
                        self.seatTableView.reloadData()
                    }else{
                        showErrorMessage("Departed flight cannot be changed.")
                    }
                    
                }else{
                    showErrorMessage("Departed flight cannot be changed.")
                }
            }
        }else{
            if indexPath.section != 1{
                
                if journeys[indexPath.section]["flight_status"] as! String != "departed"{
                    let cell = self.seatTableView.cellForRowAtIndexPath(indexPath) as! CustomSeatSelectionTableViewCell
                    cell.rowView.backgroundColor = UIColor.yellowColor()
                    sectionSelect = indexPath
                    self.seatTableView.reloadData()
                }else{
                    showErrorMessage("Departed flight cannot be changed.")
                }
            }
        }
        
    }
    
    var isGoingSame = Bool()
    var isReturnSame = Bool()
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        if journeys.count == 2{
            
            let goingSeatSelection = NSMutableArray()
            let returnSeatSelection = NSMutableArray()
            let tempDict = NSMutableDictionary()
            
            for (keys, data) in seatDict{
                let newSeat = NSMutableDictionary()
                for (passengerKey, passengerDetail) in data as! NSDictionary{
                    newSeat.setValue(passengerDetail, forKey: passengerKey as! String)
                }
                
                if keys == "0"{
                    goingSeatSelection.addObject(newSeat)
                    
                    if (data.count >= seatTypeDict[keys]?.count){
                        isGoingSame = true
                    }else{
                        isGoingSame = false
                    }
                    
                }else{
                    returnSeatSelection.addObject(newSeat)
                    
                    if (data.count >= seatTypeDict[keys]?.count){
                        isReturnSame = true
                    }else{
                        isReturnSame = false
                    }
                    
                }
                
            }
            
            if goingSeatSelection.count == 0{
                goingSeatSelection.addObject(tempDict)
            }else if returnSeatSelection.count == 0{
                returnSeatSelection.addObject(tempDict)
            }
            
            if isSelect{
                
                if isGoingSame || isReturnSame{
                    showLoading()
                    
                    FireFlyProvider.request(.ChangeSeat(goingSeatSelection[0], returnSeatSelection[0], bookId, signature, pnr), completion: { (result) -> () in
                        
                        switch result {
                        case .Success(let successResult):
                            do {
                                
                                let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                
                                if json["status"] == "success"{
                                    //
                                    let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                    let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
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
                }else{
                    showErrorMessage("Selected seat cannot be remove")
                }
                
            }else{
                showErrorMessage("Departed flight cannot be changed.")
            }
            
            
        }else{
            
            let goingSeatSelection = NSMutableArray()
            let tempDict = NSMutableDictionary()
            let returnSeatSelection = NSMutableArray()
            
            if seatDict.count != 0{
                
                for (_, data) in seatDict{
                    
                    let newSeat = NSMutableDictionary()
                    
                    for (passengerKey, passengerDetail) in data as! NSDictionary{
                        
                        newSeat.setValue(passengerDetail, forKey: passengerKey as! String)
                        
                    }
                    goingSeatSelection.addObject(newSeat)
                    
                }
                
                if goingSeatSelection.count == 0{
                    goingSeatSelection.addObject(tempDict)
                }
                
                returnSeatSelection.addObject(tempDict)
                
                if isSelect{
                    showLoading()
                    
                    FireFlyProvider.request(.ChangeSeat(goingSeatSelection[0], returnSeatSelection[0], bookId, signature, pnr), completion: { (result) -> () in
                        
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
                }else{
                    showErrorMessage("Departed flight cannot be changed.")
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
