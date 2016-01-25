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
        
        var newSeat = NSMutableArray()
        var seatArray = NSMutableArray()
        var seatData = NSMutableArray()
        let passengersArr = NSMutableArray()
        var countJourney = 0
        for info in journeys{
            
            let data = NSMutableDictionary()
            let departureStationName = info["departure_station_name"] as! String
            let departureStation =  info["departure_station"] as! String
            let arrivalStation = info["arrival_station"] as! String
            let arrivalStationName = info["arrival_station_name"] as! String
            let passengerInfo = info["passengers"] as! NSArray
            let seat = NSMutableArray()
            seatData = info["seat_info"] as! NSMutableArray
            newSeat = seatData.mutableCopy() as! NSMutableArray
            var seatIndex = 0
            
            while newSeat.count != 0{
                if seatIndex == 3{
                    
                    seatIndex = 0
                    seatArray.addObject(newSeat[0])
                    seat.addObject(seatArray)
                    newSeat.removeObjectAtIndex(0)
                    seatArray = NSMutableArray()
                    
                }else{
                    
                    seatArray.addObject(newSeat[0])
                    newSeat.removeObjectAtIndex(0)
                    seatIndex++
                    
                }
            }
            
            var i = 0
            
            for seatInfo in passengerInfo{
                
                for seatRowInfo in seat{
                    
                    for info in seatRowInfo as! NSArray{
                        
                        if seatInfo["unit_designator"] as! String == info["seat_number"] as! String{
                            if countJourney == 0{
                                passengers1.updateValue(info as! NSDictionary, forKey: "\(i)")
                                seatDict.updateValue(passengers1, forKey: "\(countJourney)")
                            }else{
                                passengers2.updateValue(info as! NSDictionary, forKey: "\(i)")
                                seatDict.updateValue(passengers2, forKey: "\(countJourney)")
                            }
                            break
                        }
                        
                    }
                    
                }
                i++
                
            }
            
                passengersArr.addObject(info["passengers"] as! NSArray)
            
            data.setValue(departureStation, forKey: "departure_station")
            data.setValue(departureStationName, forKey: "departure_station_name")
            data.setValue(arrivalStation, forKey: "arrival_station")
            data.setValue(arrivalStationName, forKey: "arrival_station_name")
            data.setValue(seat, forKey: "seat_info")
            
            details.addObject(data)
            countJourney++
            
        }
        
        if isEdit{
            passenger = passengersArr.mutableCopy() as! NSArray
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        if seatDict.count == 0 || seatDict.count != details.count{
            self.showToastMessage("Please select seat first")
        }else{
            if seatDict.count == 2{
                
                if seatDict["0"]!.count == 0 || seatDict["1"]!.count == 0{
                    self.showToastMessage("Please select seat first")
                }else{
                    
                    let goingSeatSelection = NSMutableArray()
                    let returnSeatSelection = NSMutableArray()
                    for i in 0...seatDict.count-1{
                        let newSeat = NSMutableDictionary()
                        let newDetail = NSMutableDictionary()
                        for j in 0...seatDict["\(i)"]!.count-1{
                            
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
                    
                    self.showHud()
                    
                    FireFlyProvider.request(.ChangeSeat(goingSeatSelection[0], returnSeatSelection[0], bookId, signature, pnr), completion: { (result) -> () in
                        
                        switch result {
                        case .Success(let successResult):
                            do {
                                self.hideHud()
                                let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                
                                if json["status"] == "success"{
                                    //self.showToastMessage(json["status"].string!)
                                    let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                    let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                                    manageFlightVC.isConfirm = true
                                    manageFlightVC.itineraryData = json.object as! NSDictionary
                                    self.navigationController!.pushViewController(manageFlightVC, animated: true)
                                    
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
                
            }else{
                
                if seatDict["0"]!.count == 0{
                    self.showToastMessage("Please select seat first")
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
                    
                    self.showHud()
                    
                    FireFlyProvider.request(.ChangeSeat(goingSeatSelection[0], returnSeatSelection[0], bookId, signature, pnr), completion: { (result) -> () in
                        
                        switch result {
                        case .Success(let successResult):
                            do {
                                self.hideHud()
                                let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                
                                if json["status"] == "success"{
                                    let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                    let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                                    manageFlightVC.isConfirm = true
                                    manageFlightVC.itineraryData = json.object as! NSDictionary
                                    self.navigationController!.pushViewController(manageFlightVC, animated: true)
                                    
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
