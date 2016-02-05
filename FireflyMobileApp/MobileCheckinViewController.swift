//
//  MobileCheckinViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/1/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLForm

class MobileCheckinViewController: BaseXLFormViewController {

    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        continueBtn.layer.cornerRadius = 10.0
        
        getDepartureAirport()
        initializeForm()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshArrivingCode:", name: "refreshArrivingCode", object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshArrivingCode(notif : NSNotification){
        travel = [NSDictionary]()
        getArrivalAirport(notif.userInfo!["departStationCode"] as! String)
        self.form.removeFormRowWithTag(Tags.ValidationArriving)
        
        var row : XLFormRowDescriptor
        
        // Arriving
        row = XLFormRowDescriptor(tag: Tags.ValidationArriving, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Arriving:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for arrivingStation in travel{
            tempArray.append(XLFormOptionsObject(value: arrivingStation["location_code"], displayText: arrivingStation["travel_location"] as! String))
        }
        row.selectorOptions = tempArray
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationDeparting)
        
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        let section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        
        //Confirmation Number
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmationNumber, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Confirmation Number:*")
        row.required = true
        section.addFormRow(row)

        
        // Departing
        row = XLFormRowDescriptor(tag: Tags.ValidationDeparting, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Departing:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for departureStation in location{
            tempArray.append(XLFormOptionsObject(value: departureStation["location_code"], displayText: departureStation["location"] as! String))
        }
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Arriving
        row = XLFormRowDescriptor(tag: Tags.ValidationArriving, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Arriving:*")
        row.disabled = NSNumber(bool: true)
        row.required = true
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate{
            
            let pnr = self.formValues()[Tags.ValidationConfirmationNumber] as! String
            let departure_station_code = getStationCode(self.formValues()[Tags.ValidationDeparting] as! String, locArr: location, direction : "Departing")
            //self.formValues()[Tags.ValidationDeparting] as! String
            let arrival_station_code = getStationCode(self.formValues()[Tags.ValidationArriving] as! String, locArr: travel, direction : "Arriving")
            showHud()
            FireFlyProvider.request(.CheckIn("", pnr, "", departure_station_code, arrival_station_code), completion: { (result) -> () in
                self.hideHud()
                switch result {
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if  json["status"].string == "success"{
                            let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                            let checkInDetailVC = storyboard.instantiateViewControllerWithIdentifier("MobileCheckInDetailVC") as! MobileCheckInDetailViewController
                            checkInDetailVC.checkInDetail = json.object as! NSDictionary
                            checkInDetailVC.pnr = pnr
                            self.navigationController!.pushViewController(checkInDetailVC, animated: true)
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
