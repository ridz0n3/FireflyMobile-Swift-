//
//  CommonSearchDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/15/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class CommonSearchDetailViewController: BaseXLFormViewController {

    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        continueBtn.layer.cornerRadius = 10.0
        
        getDepartureAirport("checkIn")
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
        getArrivalAirport(notif.userInfo!["departStationCode"] as! String, module : "checkIn")
        self.form.removeFormRowWithTag(Tags.ValidationArriving)
        
        var row : XLFormRowDescriptor
        
        // Arriving
        row = XLFormRowDescriptor(tag: Tags.ValidationArriving, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Arriving:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for arrivingStation in travel{
            tempArray.append(XLFormOptionsObject(value: arrivingStation["travel_location_code"], displayText: arrivingStation["travel_location"] as! String))
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
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmationNumber, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Confirmation Number:*")
        row.required = true
        //row.value = "y4pcsf"
        section.addFormRow(row)
        
        
        // Departing
        row = XLFormRowDescriptor(tag: Tags.ValidationDeparting, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Departing:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for departureStation in location{
            tempArray.append(XLFormOptionsObject(value: departureStation["location_code"], displayText: departureStation["location"] as! String))
        }
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Arriving
        row = XLFormRowDescriptor(tag: Tags.ValidationArriving, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Arriving:*")
        row.disabled = NSNumber(bool: true)
        row.required = true
        section.addFormRow(row)
        
        self.form = form
        
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
