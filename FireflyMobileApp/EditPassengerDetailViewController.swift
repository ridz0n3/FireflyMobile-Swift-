//
//  EditPassengerDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class EditPassengerDetailViewController: CommonPassengerDetailViewController {

    var passengerInformation = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for data in passengerInformation{
            
            if data["type"] as! String == "Adult"{
                adultData.addObject(data)
            }else{
                infantData.addObject(data)
            }
            
        }
        
        adultArray = NSMutableArray()
        adultCount = adultData.count
        infantCount = infantData.count
        
        initializeForm()
    }
    
    func initializeForm(){
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        for adult in 1...adultCount{
            
            var i = adult
            i--
            
            let adultData:[String:String] = ["passenger_code":"\(i)", "passenger_name":"Adult \(adult)"]
            adultArray.addObject(adultData)

            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Adult \(adult)")
            form.addFormSection(section)
            
            // Title
            
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Title:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            titleArray = defaults.objectForKey("title") as! NSMutableArray
            for title in titleArray{
                tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            //first name
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
            row.required = true
            section.addFormRow(row)
            
            //last name
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
            row.required = true
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
            row.required = true
            section.addFormRow(row)
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
            
            tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Nationality:*")
            
            tempArray = [AnyObject]()
            countryArray = defaults.objectForKey("country") as! NSMutableArray
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
            row.required = true
            section.addFormRow(row)
            
            // Enrich Loyalty No
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Enrich Loyalty No:")
            section.addFormRow(row)

            
        }
        
        for infant in 1...infantCount{
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Infant \(infant)")
            form.addFormSection(section)
            
            // Title
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelWith, infant), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Traveling with:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            for passenger in adultArray{
                tempArray.append(XLFormOptionsObject(value: passenger["passenger_code"], displayText: passenger["passenger_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Gender
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationGender, infant), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Gender:*")
            
            tempArray = [AnyObject]()
            for gender in genderArray{
                tempArray.append(XLFormOptionsObject(value: gender["gender_code"], displayText: gender["gender_name"]))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // First name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationFirstName, infant), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
            row.required = true
            section.addFormRow(row)
            
            // Last Name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationLastName, infant), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
            row.required = true
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDate, infant), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
            row.required = true
            section.addFormRow(row)
            
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelDoc, infant), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
            
            tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationCountry, infant), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Nationality:*")
            
            tempArray = [AnyObject]()
            countryArray = defaults.objectForKey("country") as! NSMutableArray
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDocumentNo, infant), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
            row.required = true
            section.addFormRow(row)
        }
        
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
