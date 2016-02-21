//
//  EditPassengerDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON

class EditPassengerDetailViewController: CommonPassengerDetailViewController {

    var passengerInformation = NSArray()
    var itineraryData = NSDictionary()
    var pnr = String()
    var bookingId = String()
    var signature = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for data in passengerInformation{
            
            if data["type"] as! String == "Adult"{
                adultDetails.addObject(data)
            }else{
                infantDetails.addObject(data)
            }
            
        }
        
        adultArray = NSMutableArray()
        
        adultCount = adultDetails.count
        infantCount = infantDetails.count
        
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
            for title in titleArray{
                tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
                if adultDetails[i]["title"] as! String == title["title_code"] as! String{
                    row.value = title["title_name"] as! String
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            //first name
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
            row.required = true
            row.disabled = NSNumber(bool: true)
            row.value = adultDetails[i]["first_name"] as! String
            section.addFormRow(row)
            
            //last name
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
            row.required = true
            row.disabled = NSNumber(bool: true)
            row.value = adultDetails[i]["last_name"] as! String
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
            row.required = true
            row.value = adultDetails[i]["dob"] as! String
            section.addFormRow(row)
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
            
            tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
                
                if adultDetails[i]["travel_document"] as? String == travel["doc_code"]{
                    row.value = travel["doc_name"]
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Issuing Country:*")
            
            tempArray = [AnyObject]()
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                
                if adultDetails[i]["issuing_country"] as? String == country["country_code"] as? String{
                    row.value = country["country_name"] as! String
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
            row.required = true
            row.value = adultDetails[i]["document_number"] as! String
            section.addFormRow(row)
            
            // Enrich Loyalty No
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Bonuslink Card Number:")
            row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
            row.value = adultDetails[i]["bonuslink"] as! String
            section.addFormRow(row)
            
        }
        
        if infantCount != 0{
            for infant in 1...infantCount{
                
                var j = infant
                j--
                
                let infantDict:NSDictionary = infantDetails[j] as! NSDictionary
                
                // Basic Information - Section
                section = XLFormSectionDescriptor()
                section = XLFormSectionDescriptor.formSectionWithTitle("Infant \(infant)")
                form.addFormSection(section)
                
                // Title
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelWith, infant), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Traveling with:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
                for passenger in adultArray{
                    tempArray.append(XLFormOptionsObject(value: passenger["passenger_code"], displayText: passenger["passenger_name"] as! String))
                    
                    if "\(infantDict["traveling_with"]!)" == passenger["passenger_code"] as! String{
                        row.value = passenger["passenger_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // Gender
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationGender, infant), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Gender:*")
                
                tempArray = [AnyObject]()
                for gender in genderArray{
                    tempArray.append(XLFormOptionsObject(value: gender["gender_code"], displayText: gender["gender_name"]))
                    
                    if infantDict["gender"] as? String == gender["gender_code"]{
                        row.value = gender["gender_name"]
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // First name
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationFirstName, infant), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
                row.required = true
                row.value = infantDict["first_name"] as! String
                row.disabled = NSNumber(bool: true)
                section.addFormRow(row)
                
                // Last Name
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationLastName, infant), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
                row.required = true
                row.value = infantDict["last_name"] as! String
                row.disabled = NSNumber(bool: true)
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDate, infant), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
                row.required = true
                row.value = infantDict["dob"] as! String
                section.addFormRow(row)
                
                
                // Travel Document
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelDoc, infant), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
                
                tempArray = [AnyObject]()
                for travel in travelDoc{
                    tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
                    
                    if infantDict["travel_document"] as? String == travel["doc_code"]{
                        row.value = travel["doc_name"]
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // Country
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationCountry, infant), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Issuing Country:*")
                
                tempArray = [AnyObject]()
                for country in countryArray{
                    tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                    
                    if infantDict["issuing_country"] as? String == country["country_code"] as? String{
                        row.value = country["country_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // Document Number
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDocumentNo, infant), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
                row.required = true
                row.value = infantDict["document_number"] as! String
                section.addFormRow(row)
                
            }
        }
        
        
        self.form = form
        
        for adult in 1...adultCount{
            var i = adult
            i--
            
            let expiredDate = (adultDetails[i]["expiration_date"] as! String).componentsSeparatedByString("T")
            if adultDetails[i]["travel_document"] as! String == "P"{
                addExpiredDateRow("adult\(adult))", date: expiredDate[0])
            }
            
        }
        
        if infantCount != 0{
            for infant in 1...infantCount{
                var i = infant
                i--
                
                let expiredDate = (infantDetails[i]["expiration_date"] as! String).componentsSeparatedByString("T")
                
                if infantDetails[i]["travel_document"] as! String == "P"{
                    addExpiredDateRow("infant\(infant))", date: expiredDate[0])
                }
                
            }
        }
        
        
    }

    @IBAction func continueBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            if checkValidation(){
                let params = getFormData()
                
                showHud("open")
                
                FireFlyProvider.request(.EditPassengerDetail(params.0,params.1,bookingId, signature, pnr), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            showHud("close")
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                
                                let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                                manageFlightVC.isConfirm = true
                                manageFlightVC.itineraryData = json.object as! NSDictionary
                                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            }else if json["status"] == "error"{
                                //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                            }
                        }
                        catch {
                            
                        }
                        
                    case .Failure(let failureResult):
                        print (failureResult)
                    }
                })
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
