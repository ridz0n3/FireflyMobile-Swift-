//
//  CommonAddAdultViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/7/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class CommonAdultViewController: BaseXLFormViewController {

    var action = String()
    var adultInfo = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        if action == "add"{
            let adultTempData = ["title" : "",
                                 "first_name" : "",
                                 "last_name" : "",
                                 "dob" : "",
                                 "nationality" : "",
                                 "bonuslink_card" : ""]
            adultInfo = adultTempData as NSDictionary
        }
        initialize()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(){
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for title in titleArray{
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
            
            if title["title_code"] as! String == adultInfo["title"] as! String{
                row.value = title["title_name"] as! String
            }
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        //first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.required = true
        row.value = adultInfo["first_name"] as! String
        section.addFormRow(row)
        
        //last name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.value = adultInfo["last_name"] as! String
        row.required = true
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
        row.required = true
        if adultInfo["dob"] as! String != ""{
            row.value = formatDate(stringToDate(adultInfo["dob"] as! String))
        }
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
        
        tempArray = [AnyObject]()
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            
            if country["country_code"] as! String == adultInfo["nationality"] as! String{
                row.value = country["country_name"] as! String
            }
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Enrich Loyalty No
        row = XLFormRowDescriptor(tag: Tags.ValidationEnrichLoyaltyNo, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
        //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
        row.value = adultInfo["bonuslink_card"]! as! String
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
