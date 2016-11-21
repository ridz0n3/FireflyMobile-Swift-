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
        AnalyticsManager.sharedInstance.logScreen(GAConstants.seatSelectionScreen)
                
        var newSeat = [Dictionary<String, AnyObject>]()
        var seatArray = [Dictionary<String, AnyObject>]()
        var seatData = [Dictionary<String, AnyObject>]()
        for info in journeys as! [Dictionary<String, AnyObject>]{
            
            var data = Dictionary<String,AnyObject>()
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
                    seat.add(seatArray)
                    newSeat.removeAtIndex(0)
                    seatArray = [Dictionary<String, AnyObject>]()
                    
                }else{
                    
                    seatArray.append(newSeat[0])
                    newSeat.removeAtIndex(0)
                    seatIndex += 1
                    
                }
            }
            
            data["departure_station"] = departureStation
            data["departure_station_name"] = departureStationName
            data["arrival_station"] = arrivalStation
            data["arrival_station_name"] = arrivalStationName
            data["seat_info"] = seat
            
            details.append(data)
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        let bookId = String(format: "%i", defaults.object(forKey: "booking_id")!.integerValue)
        let signature = defaults.object(forKey: "signature") as! String
        
        if journeys.count == 2{
            
            let goingSeatSelection = NSMutableArray()
            let returnSeatSelection = NSMutableArray()
            let tempDict = NSMutableDictionary()
            if seatDict.count != 0{
                
                for (keys, data) in seatDict{
                    let newSeat = NSMutableDictionary()
                    for (passengerKey, passengerDetail) in data as! NSDictionary{
                        newSeat.setValue(passengerDetail, forKey: passengerKey as! String)
                    }
                    
                    if keys == "0"{
                        goingSeatSelection.add(newSeat)
                    }else{
                        returnSeatSelection.add(newSeat)
                    }
                    
                }
                
                if goingSeatSelection.count == 0{
                    goingSeatSelection.add(tempDict)
                }else if returnSeatSelection.count == 0{
                    returnSeatSelection.add(tempDict)
                }
                showLoading() 
                
                FireFlyProvider.request(.SelectSeat(goingSeatSelection[0], returnSeatSelection[0], bookId, signature), completion: { (result) -> () in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                
                                defaults.setObject(json.dictionaryObject, forKey: "itenerary")
                                defaults.synchronize()
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentSummaryVC") as! PaymentSummaryViewController
                                self.navigationController!.pushViewController(paymentVC, animated: true)
                                
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
                        
                    case .failure(let failureResult):
                        
                        hideLoading()
                        showErrorMessage(failureResult.localizedDescription)
                    }
                    
                })
                
            }else{
                continueWithoutSelectSeat(signature)
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
                    goingSeatSelection.add(newSeat)
                    
                }
                
                if goingSeatSelection.count == 0{
                    goingSeatSelection.add(tempDict)
                }
                
                returnSeatSelection.add(tempDict)
                showLoading() 
                
                FireFlyProvider.request(.SelectSeat(goingSeatSelection[0], returnSeatSelection[0], bookId, signature), completion: { (result) -> () in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                
                                defaults.setObject(json.dictionaryObject, forKey: "itenerary")
                                defaults.synchronize()
                                
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentSummaryVC") as! PaymentSummaryViewController
                                self.navigationController!.pushViewController(paymentVC, animated: true)
                                
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
                        
                    case .failure(let failureResult):
                        
                        hideLoading()
                        showErrorMessage(failureResult.localizedDescription)
                    }
                    
                })
                
            }else{
                continueWithoutSelectSeat(signature)
            }
        }
    }
    
    func continueWithoutSelectSeat(signature : String){
        
        showLoading() 
        
        FireFlyProvider.request(.FlightSummary(signature), completion: { (result) -> () in
            
            switch result {
            case .success(let successResult):
                do {
                    
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if json["status"] == "success"{
                        
                        defaults.setObject(json.dictionaryObject, forKey: "itenerary")
                        defaults.synchronize()
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentSummaryVC") as! PaymentSummaryViewController
                        self.navigationController!.pushViewController(paymentVC, animated: true)
                        
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
                
            case .failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.localizedDescription)
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
