//
//  AddSeatSelectionViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/19/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddSeatSelectionViewController: CommonSeatSelectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        journeys = defaults.objectForKey("journey") as! [AnyObject]
        passenger = defaults.objectForKey("passenger") as! NSArray
        
        var newSeat = [Dictionary<String, AnyObject>]()
        var seatArray = [Dictionary<String, AnyObject>]()
        var seatData = [Dictionary<String, AnyObject>]()
        for info in journeys as! [Dictionary<String, AnyObject>]{
            
            let data = NSMutableDictionary()
            let departureStationName = info["departure_station_name"] as! String
            let departureStation =  info["departure_station"] as! String
            let arrivalStation = info["arrival_station"] as! String
            let arrivalStationName = info["arrival_station_name"] as! String
            let seat = NSMutableArray()
            seatData = info["seat_info"] as! [Dictionary<String, AnyObject>]
            newSeat = seatData
            var seatIndex = 0
            while newSeat.count != 0{
                if seatIndex == 3{
                    
                    seatIndex = 0
                    seatArray.append(newSeat[0])
                    seat.addObject(seatArray)
                    newSeat.removeAtIndex(0)
                    seatArray = [Dictionary<String, AnyObject>]()
                    
                }else{
                    
                    seatArray.append(newSeat[0])
                    newSeat.removeAtIndex(0)
                    seatIndex++
                    
                }
            }
            
            data.setValue(departureStation, forKey: "departure_station")
            data.setValue(departureStationName, forKey: "departure_station_name")
            data.setValue(arrivalStation, forKey: "arrival_station")
            data.setValue(arrivalStationName, forKey: "arrival_station_name")
            data.setValue(seat, forKey: "seat_info")
            
            details.addObject(data)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        let bookId = String(format: "%i", defaults.objectForKey("booking_id")!.integerValue)
        let signature = defaults.objectForKey("signature") as! String
        
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
                    
                    showHud("open")
                    
                    FireFlyProvider.request(.SelectSeat(goingSeatSelection[0], returnSeatSelection[0], bookId, signature), completion: { (result) -> () in
                        
                        switch result {
                        case .Success(let successResult):
                            do {
                                showHud("close")
                                let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                
                                if json["status"] == "success"{
                                    
                                    defaults.setObject(json.dictionaryObject, forKey: "itenerary")
                                    defaults.synchronize()
                                    let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                    let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentSummaryVC") as! PaymentSummaryViewController
                                    self.navigationController!.pushViewController(paymentVC, animated: true)
                                    
                                }else if json["status"] == "error"{
                                    //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                                }
                            }
                            catch {
                                
                            }
                            
                        case .Failure(let failureResult):
                            showHud("close")
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
                        
                        for j in 0...seatDict["\(i)"]!.count-1{
                            let newDetail = NSMutableDictionary()
                            newDetail.setValue(seatDict["\(i)"]!["\(j)"]!!["seat_number"], forKey: "seat_number")
                            newDetail.setValue(seatDict["\(i)"]!["\(j)"]!!["compartment_designator"], forKey: "compartment_designator")
                            
                            newSeat.setValue(newDetail, forKeyPath: "\(j)")
                            
                        }
                        
                        goingSeatSelection.addObject(newSeat)
                        
                    }
                    
                    returnSeatSelection.addObject(tempDict)
                    
                    showHud("open")
                    
                    FireFlyProvider.request(.SelectSeat(goingSeatSelection[0], returnSeatSelection[0], bookId, signature), completion: { (result) -> () in
                        
                        switch result {
                        case .Success(let successResult):
                            do {
                                showHud("close")
                                let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                
                                if json["status"] == "success"{
                                    
                                    defaults.setObject(json.dictionaryObject, forKey: "itenerary")
                                    defaults.synchronize()
                                    
                                    let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                    let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentSummaryVC") as! PaymentSummaryViewController
                                    self.navigationController!.pushViewController(paymentVC, animated: true)
                                    
                                }else if json["status"] == "error"{
                                    //showErrorMessage(json["message"].string!)
                                    showErrorMessage(json["message"].string!)
                                }
                            }
                            catch {
                                
                            }
                            
                        case .Failure(let failureResult):
                            showHud("close")
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
