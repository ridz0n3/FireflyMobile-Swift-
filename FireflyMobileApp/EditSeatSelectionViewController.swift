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
        
        var newSeat = [Dictionary<String,AnyObject>]()
        var seatArray = [Dictionary<String,AnyObject>]()
        var seatData = [Dictionary<String,AnyObject>]()
        var passengersArr = [AnyObject]()
        var countJourney = 0
        for info in journeys as! [Dictionary<String, AnyObject>]{
            
            let data = NSMutableDictionary()
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
                    seatIndex++
                    
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
                            }else{
                                passengers2.updateValue(tempInfo as NSDictionary, forKey: "\(i)")
                                seatDict.updateValue(passengers2, forKey: "\(countJourney)")
                            }
                            break
                        }
                        
                    }
                    
                }
                i++
                
            }
            
            passengersArr.append(passengerInfo)
            
            data.setValue(departureStation, forKey: "departure_station")
            data.setValue(departureStationName, forKey: "departure_station_name")
            data.setValue(arrivalStation, forKey: "arrival_station")
            data.setValue(arrivalStationName, forKey: "arrival_station_name")
            data.setValue(seat, forKey: "seat_info")
            
            details.addObject(data)
            countJourney++
            
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
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        if seatDict.count == 0 || seatDict.count != details.count{
            showErrorMessage("LabelErrorSelectSeat".localized)
        }else{
            if seatDict.count == 2{
                
                if seatDict["0"]!.count == 0 || seatDict["1"]!.count == 0{
                    showErrorMessage("LabelErrorSelectSeat".localized)
                }else{
                    
                    let goingSeatSelection = NSMutableArray()
                    let returnSeatSelection = NSMutableArray()
                    for i in 0...seatDict.count-1{
                        let newSeat = NSMutableDictionary()
                        
                        for j in 0...seatDict["\(i)"]!.count-1{
                            let newDetail = NSMutableDictionary()
                            newDetail.setValue(seatDict["\(i)"]!["\(j)"]!!["seat_number"], forKey: "seat_number")
                            newDetail.setValue(seatDict["\(i)"]!["\(j)"]!!["compartment_designator"], forKey: "compartment_designator")
                            
                            newSeat.setValue(newDetail, forKeyPath: "\(j)")
                            
                        }
                        
                        if i == 0{
                            goingSeatSelection.addObject(newSeat)
                        }else{
                            returnSeatSelection.addObject(newSeat)
                        }
                    }
                    
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
                
            }else{
                
                if seatDict["0"]!.count == 0{
                    showErrorMessage("LabelErrorSelectSeat".localized)
                }else{
                    
                    let goingSeatSelection = NSMutableArray()
                    let tempDict = NSMutableDictionary()
                    let returnSeatSelection = NSMutableArray()
                    
                    for i in 0...seatDict.count-1{
                        let newSeat = NSMutableDictionary()
                        let newDetail = NSMutableDictionary()
                        for j in 0...seatDict["\(i)"]!.count-1{
                            
                            newDetail.setValue(seatDict["\(i)"]!["\(j)"]!!["seat_number"], forKey: "seat_number")
                            newDetail.setValue(seatDict["\(i)"]!["\(j)"]!!["compartment_designator"], forKey: "compartment_designator")
                            
                            newSeat.setValue(newDetail, forKeyPath: "\(j)")
                            
                        }
                        
                        goingSeatSelection.addObject(newSeat)
                        
                    }
                    
                    returnSeatSelection.addObject(tempDict)
                    
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
