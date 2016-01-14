//
//  AddPassengerDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLForm

class AddPassengerDetailViewController: CommonPassengerDetailViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adultArray = NSMutableArray()
        adultCount = (defaults.objectForKey("adult")?.integerValue)!
        infantCount = (defaults.objectForKey("infant")?.integerValue)!
        
        initializeForm()
    }

    func initializeForm() {
        
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        for adult in 1...adultCount{
            
            var i = adult
            i--
            
            let adultData:[String:String] = ["passenger_code":"\(i)", "passenger_name":"Adult \(adult)"]
            adultArray.addObject(adultData)
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Adult \(adult)")
            form.addFormSection(section)
            
            
            if try! LoginManager.sharedInstance.isLogin() && adult == 1 {
                
                // Title
                
                let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
                
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Title:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
                titleArray = defaults.objectForKey("title") as! NSMutableArray
                for title in titleArray{
                    tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
                    
                    if title["title_code"] as! String == userInfo["title"] as! String{
                        row.value = title["title_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                //first name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
                row.required = true
                row.value = "\(userInfo["first_name"]!)"
                section.addFormRow(row)
                
                //last name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
                row.required = true
                row.value = "\(userInfo["last_name"]!)"
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
                row.value = "\(userInfo["DOB"]!)"
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
                    
                    if country["country_code"] as! String == userInfo["contact_country"] as! String{
                        row.value = country["country_name"] as! String
                    }
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
                
            }else{
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
            
        }
        
        for var i = 0; i < infantCount; i = i + 1{
            var j = i
            j = j + 1
            
            
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Infant \(j)")
            form.addFormSection(section)
            
            // Title
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelWith, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Traveling with:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            for passenger in adultArray{
                tempArray.append(XLFormOptionsObject(value: passenger["passenger_code"], displayText: passenger["passenger_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Gender
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationGender, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Gender:*")
            
            tempArray = [AnyObject]()
            for gender in genderArray{
                tempArray.append(XLFormOptionsObject(value: gender["gender_code"], displayText: gender["gender_name"]))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // First name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationFirstName, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
            row.required = true
            section.addFormRow(row)
            
            // Last Name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationLastName, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
            row.required = true
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDate, j), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
            row.required = true
            section.addFormRow(row)
            
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelDoc, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
            
            tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationCountry, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Nationality:*")
            
            tempArray = [AnyObject]()
            countryArray = defaults.objectForKey("country") as! NSMutableArray
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDocumentNo, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
            row.required = true
            section.addFormRow(row)
        }
        
        self.form = form
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            var countAdultAge = Int()
            var countMaxAdultAge = Int()
            var countInfantAge = Int()
            var countMaxInfantAge = Int()
            
            let currentDate: NSDate = NSDate()
            let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            calendar.timeZone = NSTimeZone(name: "UTC")!
            
            for var i = 0; i < adultCount; i = i + 1{
                var count = i
                count++
                
                let selectDate: NSDate = stringToDate(formValues()[String(format: "%@(adult%i)", Tags.ValidationDate, count)]! as! String)
                
                let component: NSDateComponents = NSDateComponents()
                component.calendar = calendar
                component.year = -2
                let adultMinAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
                
                component.year = -12
                let adultMaxAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
                
                if selectDate.compare(stringToDate(formatDate(adultMinAge))) == NSComparisonResult.OrderedDescending{
                    //age below 2 years old
                    countAdultAge++
                }else if selectDate.compare(stringToDate(formatDate(adultMaxAge))) == NSComparisonResult.OrderedDescending{
                    //age below 12 years old
                    countMaxAdultAge++
                }
            }
            
            for var i = 0; i < infantCount; i = i + 1{
                
                var count = i
                count++
                
                let selectDate: NSDate = stringToDate(formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]! as! String)
                
                let component: NSDateComponents = NSDateComponents()
                component.calendar = calendar
                component.day = -9
                let infantMinAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
                
                component.year = -2
                let infantMaxAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
                
                if selectDate.compare(stringToDate(formatDate(infantMinAge))) == NSComparisonResult.OrderedDescending{
                    //age below 9 days
                    countInfantAge++
                }else if selectDate.compare(stringToDate(formatDate(infantMaxAge))) == NSComparisonResult.OrderedAscending{
                    //age above 24months
                    countMaxInfantAge++
                }
                
            }
            
            if countAdultAge > 0{
                showToastMessage("Guest(s) must be above 2 years old at the date(s) of travel.")
            }else if countMaxAdultAge > 0 && adultCount == 1{
                showToastMessage("There must be at least one(1) passenger above 12 years old at the date(s) of travel")
            }else if countMaxAdultAge > 0 && adultCount > 1{
                showToastMessage("Passenger less than 12 years old must be accompanied by an 18 years old passenger.")
            }else if countInfantAge > 0 || countMaxInfantAge > 0{
                showToastMessage("Infant(s) must be within the age of 9 days - 24 months at date(s) of travel.")
            }else{
                let params = getFormData()
                
                showHud()
                
                FireFlyProvider.request(.PassengerDetail(params.0,params.1,params.2, params.3), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            self.hideHud()
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                self.showToastMessage(json["status"].string!)
                                
                                if json["insurance"].object["status"] as! String == "N"{
                                    defaults.setObject("", forKey: "insurance_status")
                                }else{
                                    defaults.setObject(json["insurance"].object, forKey: "insurance_status")
                                    defaults.synchronize()
                                }
                                
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let contactDetailVC = storyboard.instantiateViewControllerWithIdentifier("ContactDetailVC") as! AddContactDetailViewController
                                self.navigationController!.pushViewController(contactDetailVC, animated: true)
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
