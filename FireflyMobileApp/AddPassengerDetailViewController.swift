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
        
        adultArray = [Dictionary<String,AnyObject>]()
        flightType = defaults.objectForKey("flightType") as! String
        adultCount = (defaults.objectForKey("adult")?.integerValue)!
        infantCount = (defaults.objectForKey("infants")?.integerValue)!
        module = "addPassenger"
        initializeForm()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.passengerDetailsScreen)
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        if try! LoginManager.sharedInstance.isLogin(){
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Family & Friends")
            form.addFormSection(section)
        }
        for adult in 1...adultCount{
            
            var i = adult
            i -= 1
            
            let adultData:[String:String] = ["passenger_code":"\(i)", "passenger_name":"Adult \(adult)"]
            adultArray.append(adultData)
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("ADULT \(adult)")
            form.addFormSection(section)
            
            if try! LoginManager.sharedInstance.isLogin() && adult == 1 {
                
                // Title
                
                let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
                
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
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
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
                //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
                row.required = true
                row.value = "\(userInfo["first_name"]!)"
                section.addFormRow(row)
                
                //last name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
                //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
                row.required = true
                row.value = "\(userInfo["last_name"]!)"
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
                row.value = formatDate(stringToDate(userInfo["DOB"] as! String))//"\(userInfo["DOB"]!)"
                row.required = true
                section.addFormRow(row)
                
                // Travel Document
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Travel Document:*")
                
                tempArray = [AnyObject]()
                for travel in travelDoc{
                    tempArray.append(XLFormOptionsObject(value: travel["doc_code"] as! String, displayText: travel["doc_name"] as! String))
                }
                
                row.selectorOptions = tempArray
                row.required = true
                //section.addFormRow(row)
                
                // Country
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
                
                tempArray = [AnyObject]()
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
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Document No:*")
                row.required = true
                //section.addFormRow(row)
                
                
                if flightType == "FY"{
                    
                // Enrich Loyalty No
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
                //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
                row.value = "\(userInfo["bonuslink"]!)"
                section.addFormRow(row)
                }
                
            }else{
                // Title
                
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
                for title in titleArray{
                    tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                //first name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
                //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
                row.required = true
                section.addFormRow(row)
                
                //last name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
                //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
                row.required = true
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
                row.required = true
                section.addFormRow(row)
                
                // Travel Document
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Travel Document:*")
                
                tempArray = [AnyObject]()
                for travel in travelDoc{
                    tempArray.append(XLFormOptionsObject(value: travel["doc_code"] as! String, displayText: travel["doc_name"] as! String))
                }
                
                row.selectorOptions = tempArray
                row.required = true
                //section.addFormRow(row)
                
                // Country
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
                
                tempArray = [AnyObject]()
                for country in countryArray{
                    tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // Document Number
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Document No:*")
                row.required = true
                //section.addFormRow(row)
                
                if flightType == "FY"{
                // Enrich Loyalty No
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
                //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
                section.addFormRow(row)
                }
            }
            
        }
        
        for var i = 0; i < infantCount; i = i + 1{
            var j = i
            j = j + 1
            
            
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("INFANT \(j)")
            form.addFormSection(section)
            
            // Title
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelWith, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Traveling with:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            for passenger in adultArray{
                tempArray.append(XLFormOptionsObject(value: passenger["passenger_code"], displayText: passenger["passenger_name"] as! String))
            }
            row.value = adultArray[i]["passenger_name"] as! String
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Gender
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationGender, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Gender:*")
            
            tempArray = [AnyObject]()
            for gender in genderArray{
                tempArray.append(XLFormOptionsObject(value: gender["gender_code"] as! String, displayText: gender["gender_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // First name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationFirstName, j), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
            //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
            row.required = true
            section.addFormRow(row)
            
            // Last Name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationLastName, j), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
            //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
            row.required = true
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDate, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
            row.required = true
            section.addFormRow(row)
            
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelDoc, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Travel Document:*")
            
            tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"] as! String, displayText: travel["doc_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            //section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationCountry, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
            
            tempArray = [AnyObject]()
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDocumentNo, j), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Document No:*")
            row.required = true
            //section.addFormRow(row)
        }
        
        self.form = form
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            let params = getFormData()
            
            if params.4{
                showErrorMessage("Passenger name is duplicated.")
            }else if !params.5 && params.1.count != 0{
                showErrorMessage("You can only assign one infant to one guest.")
            }else{
                
                showLoading()
                FireFlyProvider.request(.PassengerDetail(params.0,params.1,params.2, params.3, flightType), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                
                                if json["insurance"].dictionaryValue["status"]!.string == "N"{
                                    defaults.setObject("", forKey: "insurance_status")
                                }else{
                                    defaults.setObject(json["insurance"].object, forKey: "insurance_status")
                                    defaults.synchronize()
                                }
                                
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let contactDetailVC = storyboard.instantiateViewControllerWithIdentifier("ContactDetailVC") as! AddContactDetailViewController
                                
                                if let meal = json["meal"].arrayObject{
                                    contactDetailVC.meals = meal
                                }
                                
                                self.navigationController!.pushViewController(contactDetailVC, animated: true)
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
                        
                    case .Failure(let failureResult):
                        
                        hideLoading()
                        
                        showErrorMessage(failureResult.nsError.localizedDescription)
                    }
                })
            }
        }
        
    }
    
    
}
