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
    
    var passengerInformation = [Dictionary<String, AnyObject>]()
    var itineraryData = NSDictionary()
    var pnr = String()
    var bookingId = String()
    var signature = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.editPassengerDetailScreen)
        for data in passengerInformation{
            
            if data["type"] as! String == "Adult"{
                adultDetails.append(data)
            }else{
                infantDetails.append(data)
            }
            
        }
        module = "editPassenger"
        adultArray = [Dictionary<String, AnyObject>]()
        
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
            i -= 1
            
            let adultData:[String:String] = ["passenger_code":"\(i)", "passenger_name":"Adult \(adult)"]
            adultArray.append(adultData as [String : AnyObject])
            
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSection(withTitle: "ADULT \(adult)")
            form.addFormSection(section)
            
            // Title
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            for title in titleArray{
                tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
                if adultDetails[i]["title"] as! String == title["title_code"] as! String{
                    row.value = title["title_name"] as! String
                }
            }
            
            row.selectorOptions = tempArray
            row.isRequired = true
            section.addFormRow(row)
            
            //first name
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
            row.isRequired = true
            row.disabled = NSNumber(value: true)
            row.value = adultDetails[i]["first_name"] as! String
            section.addFormRow(row)
            
            //last name
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
            row.isRequired = true
            row.disabled = NSNumber(value: true)
            row.value = adultDetails[i]["last_name"] as! String
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
            row.isRequired = true
            let dateArr = (adultDetails[i]["dob"] as! String).components(separatedBy: "-")
            row.value = formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"))
            section.addFormRow(row)
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Travel Document:*")
            
            tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"]!, displayText: travel["doc_name"]!))
                
                if adultDetails[i]["travel_document"] as? String == travel["doc_code"]!{
                    row.value = travel["doc_name"]
                }
            }
            
            row.selectorOptions = tempArray
            row.isRequired = true
            //section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
            
            tempArray = [AnyObject]()
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                
                if adultDetails[i]["issuing_country"] as? String == country["country_code"] as? String{
                    row.value = country["country_name"] as! String
                }
            }
            
            row.selectorOptions = tempArray
            row.isRequired = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Document No:*")
            row.isRequired = true
            row.value = (adultDetails[i]["document_number"] as! String).xmlSimpleUnescape
            //section.addFormRow(row)
            
            if flightType == "FY"{
                // Bonuslink Loyalty No
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationBonuslinkNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
                //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
                row.value = adultDetails[i]["bonuslink"] as! String
                section.addFormRow(row)
                
                // Enrich Loyalty Number
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Enrich Loyalty Number:")
                //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
                row.value = nullIfEmpty(adultDetails[i]["enrich"] as AnyObject)
                section.addFormRow(row)
            }
            
        }
        
        if infantCount != 0{
            for infant in 1...infantCount{
                
                var j = infant
                j -= 1
                
                let infantDict:NSDictionary = infantDetails[j] as NSDictionary
                
                // Basic Information - Section
                section = XLFormSectionDescriptor()
                section = XLFormSectionDescriptor.formSection(withTitle: "INFANT \(infant)")
                form.addFormSection(section)
                
                // Title
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelWith, infant), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Traveling with:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
                for passenger in adultArray{
                    tempArray.append(XLFormOptionsObject(value: passenger["passenger_code"], displayText: passenger["passenger_name"] as! String))
                    
                    if "\(infantDict["traveling_with"]!)" == passenger["passenger_code"] as! String{
                        row.value = passenger["passenger_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.isRequired = true
                section.addFormRow(row)
                
                // Gender
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationGender, infant), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Gender:*")
                
                tempArray = [AnyObject]()
                for gender in genderArray{
                    tempArray.append(XLFormOptionsObject(value: gender["gender_code"]!, displayText: gender["gender_name"]!))
                    
                    if infantDict["gender"] as? String == gender["gender_code"]!{
                        row.value = gender["gender_name"]
                    }
                }
                
                row.selectorOptions = tempArray
                row.isRequired = true
                section.addFormRow(row)
                
                // First name
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationFirstName, infant), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
                //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
                row.isRequired = true
                row.value = infantDict["first_name"] as! String
                row.disabled = NSNumber(value: true)
                section.addFormRow(row)
                
                // Last Name
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationLastName, infant), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
                //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
                row.isRequired = true
                row.value = infantDict["last_name"] as! String
                row.disabled = NSNumber(value: true)
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDate, infant), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
                row.isRequired = true
                let dateArr = (infantDict["dob"] as! String).components(separatedBy: "-")
                row.value = formatDate(stringToDate("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"))
                //row.value = formatDate(stringToDate(infantDict["dob"] as! String))
                section.addFormRow(row)
                
                
                // Travel Document
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelDoc, infant), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Travel Document:*")
                
                tempArray = [AnyObject]()
                for travel in travelDoc{
                    tempArray.append(XLFormOptionsObject(value: travel["doc_code"]!, displayText: travel["doc_name"]!))
                    
                    if infantDict["travel_document"] as? String == travel["doc_code"]!{
                        row.value = travel["doc_name"]
                    }
                }
                
                row.selectorOptions = tempArray
                row.isRequired = true
                //section.addFormRow(row)
                
                // Country
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationCountry, infant), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
                
                tempArray = [AnyObject]()
                for country in countryArray{
                    tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                    
                    if infantDict["issuing_country"] as? String == country["country_code"] as? String{
                        row.value = country["country_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.isRequired = true
                section.addFormRow(row)
                
                // Document Number
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDocumentNo, infant), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Document No:*")
                row.isRequired = true
                row.value = (infantDict["document_number"] as! String).xmlSimpleUnescape
                //section.addFormRow(row)
                
            }
        }
        
        
        self.form = form
        
        /*
         for adult in 1...adultCount{
         var i = adult
         i -= 1
         
         let expiredDate = (adultDetails[i]["expiration_date"] as! String).components(separatedBy: "T")
         if adultDetails[i]["travel_document"] as! String == "P"{
         addExpiredDateRow("adult\(adult))", date: expiredDate[0])
         }
         
         }
         
         if infantCount != 0{
         for infant in 1...infantCount{
         var i = infant
         i -= 1
         
         let expiredDate = (infantDetails[i]["expiration_date"] as! String).components(separatedBy: "T")
         
         if infantDetails[i]["travel_document"] as! String == "P"{
         addExpiredDateRow("infant\(infant))", date: expiredDate[0])
         }
         
         }
         }
         
         */
    }
    
    @IBAction func continueBtnPressed(_ sender: AnyObject) {
        validateForm()
        
        if isValidate{
            
            let params = getFormData()
            
            if params.6{
                
                showErrorMessage("Enrich loyalty number \(params.7)is invalid.")
                
            }else{
                
                showLoading()
                
                FireFlyProvider.request(.EditPassengerDetail(params.0 as AnyObject,params.1 as AnyObject,bookingId, signature, pnr), completion: { (result) -> () in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                
                                
                                let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                let manageFlightVC = storyboard.instantiateViewController(withIdentifier: "ManageFlightMenuVC") as! ManageFlightHomeViewController
                                manageFlightVC.isConfirm = true
                                manageFlightVC.itineraryData = json.object as! NSDictionary
                                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            }else if json["status"] == "error"{
                                
                                showErrorMessage(json["message"].string!)
                            }else if json["status"].string == "401"{
                                hideLoading()
                                showErrorMessage(json["message"].string!)
                                InitialLoadManager.sharedInstance.load()
                                
                                for views in (self.navigationController?.viewControllers)!{
                                    if views.classForCoder == HomeViewController.classForCoder(){
                                        _ = self.navigationController?.popToViewController(views, animated: true)
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
