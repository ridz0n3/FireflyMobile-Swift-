//
//  CommonInfantViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/13/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class CommonInfantViewController: BaseXLFormViewController {

    var action = String()
    var infantInfo = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        if action == "add"{
            let infantTempData = ["gender" : "",
                                  "first_name" : "",
                                  "last_name" : "",
                                  "dob" : "",
                                  "nationality" : ""]
            infantInfo = infantTempData as NSDictionary
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
        
        // Gender
        row = XLFormRowDescriptor(tag: Tags.ValidationGender, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Gender:*")
        
        var tempArray = [AnyObject]()
        for gender in genderArray{
            tempArray.append(XLFormOptionsObject(value: gender["gender_code"] as! String, displayText: gender["gender_name"] as! String))
            if gender["gender_code"] as! String == infantInfo["gender"] as! String{
                row.value = gender["gender_name"] as! String
            }
            
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        //first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.value = infantInfo["first_name"] as! String
        row.required = true
        section.addFormRow(row)
        
        //last name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.value = infantInfo["last_name"] as! String
        row.required = true
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
        row.required = true
        if infantInfo["dob"] as! String != ""{
            row.value = formatDate(stringToDate(infantInfo["dob"] as! String))
        }
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
        
        tempArray = [AnyObject]()
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            
            if country["country_code"] as! String == infantInfo["nationality"] as! String{
                row.value = country["country_name"] as! String
            }
        }
        
        row.selectorOptions = tempArray
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
