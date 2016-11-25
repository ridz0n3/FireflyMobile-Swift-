//
//  AddContactDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox
import SwiftyJSON
import ActionSheetPicker_3_0
import SCLAlertView

class AddContactDetailViewController: CommonContactDetailViewController {
    
    @IBOutlet weak var chooseSeatBtn: UIButton!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var checkPassenger: M13Checkbox!
    @IBOutlet weak var yesBtn: UIButton!
    var isWantInsurance = Bool()
    var isOnePassenger = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPassenger.strokeColor = UIColor.orange
        checkPassenger.checkColor = UIColor.orange
      
        flightType = defaults.object(forKey: "flightType") as! String
        
        AnalyticsManager.sharedInstance.logScreen("\(GAConstants.contactDetailsScreen) (\(flightType))")
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactDetailViewController.refreshInsurance(_:)), name: NSNotification.Name(rawValue: "refreshInsurance"), object: nil)
        
        yesBtn.layer.cornerRadius = 10
        yesBtn.layer.borderWidth = 1
        yesBtn.layer.borderColor = UIColor.orange.cgColor
        paymentBtn.layer.cornerRadius = 10
        chooseSeatBtn.layer.cornerRadius = 10
        chooseSeatBtn.layer.borderWidth = 1
        chooseSeatBtn.layer.borderColor = UIColor.orange.cgColor
        
        if defaults.object(forKey: "flightType") as! String == "MH"{
            chooseSeatBtn.isHidden = true
            paymentBtn.setTitle("Continue", for: UIControlState.normal)
        }
        
        //var isLogin = Bool()
        
        if try! LoginManager.sharedInstance.isLogin(){
            
            if let passData = defaults.object(forKey: "passengerData") as? NSDictionary{
                
                if passData.count == 1{
                    isOnePassenger = true
                }
            }
            
            let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
            contactData = ["address1" : "",
                           "address2" : "",
                           "address3" : "",
                           "alternate_phone" : "\(userInfo["contact_alternate_phone"]!)",
                           "city" : "",
                           "company_name" : "",
                           "country" : "\(userInfo["contact_country"]!)",
                           "email" : "\(userInfo["contact_email"]!)",
                           "first_name" : "\(userInfo["first_name"]!)",
                           "last_name" : "\(userInfo["last_name"]!)",
                           "mobile_phone" : "\(userInfo["contact_mobile_phone"]!)",
                           "postcode" : "",
                           "state" : "\(userInfo["contact_state"]!)",
                           "title" : "\(userInfo["title"]!)",
                           "travel_purpose" : "1"]
            checkPassenger.checkState = M13CheckboxState.checked
            //isLogin = true
            
        }else if let passData = defaults.object(forKey: "passengerData") as? NSDictionary{
            
            if passData.count == 1{
                isOnePassenger = true
            }
            
            let tempData = passData["0"] as! NSDictionary
            
            contactData = ["address1" : "",
                           "address2" : "",
                           "address3" : "",
                           "alternate_phone" : "",
                           "city" : "",
                           "company_name" : "",
                           "country" : "\(tempData["issuing_country"]!)",
                           "email" : "",
                           "first_name" : "\(tempData["first_name"]!)",
                           "last_name" : "\(tempData["last_name"]!)",
                           "mobile_phone" : "",
                           "postcode" : "",
                           "state" : "",
                           "title" : "\(tempData["title"]!)",
                           "travel_purpose" : "1"]
            checkPassenger.checkState = M13CheckboxState.checked
        }
        
        if (defaults.object(forKey: "insurance_status") as AnyObject).classForCoder == NSString.classForCoder(){
            
            insuranceView.isHidden = true
            views.isHidden = true
            var newFrame = footerView.bounds
            newFrame.size.height = 136
            
            footerView.frame = newFrame
            
        }else{
            isWantInsurance = true
            insuranceView.isHidden = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(AddContactDetailViewController.textTapped(_:)))
            paragraph2.addGestureRecognizer(tap)
            var newFrame = footerView.bounds
            newFrame.size.height = 765
            
            footerView.frame = newFrame
            
            let insuranceData = defaults.object(forKey: "insurance_status") as! NSDictionary
            let insuranceArr = insuranceData["html"] as! NSArray
            var index = 0
            var str = ""
            
            for text in insuranceArr{
                
                if index == 0{
                    
                    let separate = (text as AnyObject).components(separatedBy: "</html>")
                    
                    str += "\(separate[0])<br>"
                    
                }else if index == 1{
                    let separate = (text as AnyObject).components(separatedBy: "<html>")
                    
                    str += "\(separate[1])"
                    
                    paragraph1.attributedText = str.html2String
                }else if index == 2{
                    paragraph2.attributedText = (text as! String).html2String
                    //let text3: String = paragraph2.text
                    //let range = text3.range(of: "[Remove]") //.rangeOfString("[Remove]")!
                    
                    //the correct solution
                   // let intIndex: Int = text3.startIndex. //.distanceTo(range!.lowerBound)
                    
                    //let myString = NSMutableAttributedString(attributedString:(text as! String).html2String)
                    //let myRange = NSRange(location: intIndex, length: 8)
                    //let myCustomAttribute = [ "MyCustomAttributeName": "some value"]
                    //myString.addAttributes(myCustomAttribute, range: myRange)
                    //myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: myRange)
                    
                    //paragraph2.attributedText = myString
                }else{
                    paragraph3.attributedText = (text as! String).html2String
                }
                
                index += 1
                
            }
            
        }
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        
        initializeForm()
    }
    
    func textTapped(_ recognizer : UITapGestureRecognizer){
        
        let textView = recognizer.view as! UITextView
        // Location of the tap in text-container coordinates
        
        let layoutManager = textView.layoutManager
        var location = recognizer.location(in: textView)
        location.x = location.x - textView.textContainerInset.left
        location.y = location.y - textView.textContainerInset.top
        
        // Find the character that's been tapped on
        
        var characterIndex = Int()
        characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < textView.textStorage.length{
            // print the character at the index
            let myRange = NSRange(location: characterIndex, length: 1)
            _ = (textView.attributedText.string as NSString).substring(with: myRange)
            
            // check if the tap location has a certain attribute
            let attributeName = "MyCustomAttributeName"
            let attributeValue = textView.attributedText.attribute(attributeName, at: characterIndex, effectiveRange: nil) as? String
            if attributeValue != nil {
                
                let storyboard = UIStoryboard(name: "Insurance", bundle: nil)
                let paymentVC = storyboard.instantiateViewController(withIdentifier: "InsuranceVC") as! InsuranceViewController
                paymentVC.vc = self
                self.navigationController!.present(paymentVC, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    @IBAction func continuePaymentBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            
            let goingSSRDict = NSMutableArray()
            let returnSSRDict = NSMutableArray()
            
            if flightType == "MH" && ssrStatus == "Y"{
                
                let timeDifference = defaults.object(forKey: "timeDifference") as! Int
                
                if timeDifference > 0{
                    var i = 0
                    for ssrInfo in meals{
                        
                        let mealList = ssrInfo["list_meal"] as! [AnyObject]
                        let passengerList = ssrInfo["passenger"] as! [AnyObject]
                        var tempDict = [AnyObject]()
                        
                        for passengerInfo in passengerList{
                            
                            let passengerDict = NSMutableDictionary()
                            for mealsInfo in mealList{
                                
                                if formValues()["\(Tags.ValidationSSRList)(\(i)\(passengerInfo["passenger_number"] as! Int))"] as! String == mealsInfo["name"] as! String{
                                    
                                    passengerDict.setValue("\(passengerInfo["passenger_number"] as! Int)", forKey: "passenger_number")
                                    passengerDict.setValue(mealsInfo["meal_code"] as! String, forKey: "meal_code")
                                    break
                                    
                                }
                                
                            }
                            
                            tempDict.append(passengerDict)
                        }
                        
                        if i == 0{
                            goingSSRDict.add(tempDict)
                        }else{
                            returnSSRDict.add(tempDict)
                        }
                        
                        i += 1
                        
                    }
                    
                    if meals.count == 1{
                        let tempDict = [AnyObject]()
                        returnSSRDict.add(tempDict)
                    }
                }else{
                    let tempDict = [AnyObject]()
                    
                    goingSSRDict.add(tempDict)
                    returnSSRDict.add(tempDict)
                }
                
            }else{
                let tempDict = [AnyObject]()
                
                goingSSRDict.add(tempDict)
                returnSSRDict.add(tempDict)
            }
            
            
            let purposeData = getPurpose(formValues()[Tags.ValidationPurpose]! as! String, purposeArr: purposeArray as [Dictionary<String, AnyObject>])
            let titleData = getTitleCode(formValues()[Tags.ValidationTitle]! as! String, titleArr: titleArray)
            let firstNameData = formValues()[Tags.ValidationFirstName]!  as! String
            let lastNameData = formValues()[Tags.ValidationLastName]! as! String
            let emailData = formValues()[Tags.ValidationUsername]!  as! String
            let countryData = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
            let mobileData = formValues()[Tags.ValidationMobileHome]!  as! String
            let alternateData = nullIfEmpty(formValues()[Tags.ValidationAlternate] as AnyObject)  
            let signatureData = defaults.object(forKey: "signature")!  as! String
            let bookIdData = String(format: "%i", (defaults.object(forKey: "booking_id")! as AnyObject).integerValue)
            let companyNameData = (nilIfEmpty(formValues()[Tags.ValidationCompanyName] as AnyObject)  ).xmlSimpleEscape
            let address1Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine1] as AnyObject)  ).xmlSimpleEscape
            let address2Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine2] as AnyObject)  ).xmlSimpleEscape
            let address3Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine3] as AnyObject)  ).xmlSimpleEscape
            let cityData = (nilIfEmpty(formValues()[Tags.ValidationTownCity] as AnyObject)  ).xmlSimpleEscape
            let stateData = getStateCode(nilIfEmpty(formValues()[Tags.ValidationState] as AnyObject) , stateArr: stateArray)
            let postcodeData = nilIfEmpty(formValues()[Tags.ValidationPostcode] as AnyObject)  
            
            var insuranceData = ""
            
            if (defaults.object(forKey: "insurance_status") as AnyObject).classForCoder == NSString.classForCoder(){
                insuranceData = "0"
            }else{
                if isWantInsurance{
                    if agreeTerm.checkState.rawValue == 1{
                        insuranceData = "\(agreeTerm.checkState.rawValue)"
                    }
                }else{
                    insuranceData = "0"
                }
            }
            
            if insuranceData == ""{
                showErrorMessage("To proceed, you need to agree with the Insurance Declaration.")
            }else{
                showLoading()
                var customer_number = String()
                
                if try! LoginManager.sharedInstance.isLogin(){
                    customer_number = defaults.object(forKey: "customer_number") as! String
                    //customer_number = userInfo["customer_number"] as! String
                }
                
                FireFlyProvider.request(.ContactDetail(flightType, bookIdData, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signatureData, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData, "N", goingSSRDict[0] as AnyObject, returnSSRDict[0] as AnyObject, customer_number), completion: { (result) -> () in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                
                                defaults.set(json.dictionaryObject, forKey: "itenerary")
                                defaults.synchronize()
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryViewController
                                self.navigationController!.pushViewController(paymentVC, animated: true)
                            }else if json["status"] == "error"{
                                showErrorMessage(json["message"].string!)
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
    
    func refreshInsurance(_ sender:NotificationCenter){
        
        isWantInsurance = false
        insuranceView.isHidden = false
        views.isHidden = true
        var newFrame = footerView.bounds
        newFrame.size.height = 330
        
        footerView.frame = newFrame
        self.tableView.tableFooterView = footerView
    }
    
    @IBAction func continueChooseSeatBtnPressed(_ sender: AnyObject) {
        validateForm()
        
        if isValidate{
            
            let purposeData = getPurpose(formValues()[Tags.ValidationPurpose]! as! String, purposeArr: purposeArray as [Dictionary<String, AnyObject>])
            let titleData = getTitleCode(formValues()[Tags.ValidationTitle]! as! String, titleArr: titleArray)
            let firstNameData = formValues()[Tags.ValidationFirstName]!  as! String
            let lastNameData = formValues()[Tags.ValidationLastName]! as! String
            let emailData = formValues()[Tags.ValidationUsername]!  as! String
            let countryData = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
            let mobileData = formValues()[Tags.ValidationMobileHome]!  as! String
            let alternateData = nullIfEmpty(formValues()[Tags.ValidationAlternate] as AnyObject)  
            let signatureData = defaults.object(forKey: "signature")!  as! String
            let bookIdData = String(format: "%i", (defaults.object(forKey: "booking_id")! as AnyObject).integerValue)
            let companyNameData = (nilIfEmpty(formValues()[Tags.ValidationCompanyName] as AnyObject)  ).xmlSimpleEscape
            let address1Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine1] as AnyObject)  ).xmlSimpleEscape
            let address2Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine2] as AnyObject)  ).xmlSimpleEscape
            let address3Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine3] as AnyObject)  ).xmlSimpleEscape
            let cityData = (nilIfEmpty(formValues()[Tags.ValidationTownCity] as AnyObject)  ).xmlSimpleEscape
            let stateData = getStateCode(nilIfEmpty(formValues()[Tags.ValidationState] as AnyObject) , stateArr: stateArray)
            let postcodeData = nilIfEmpty(formValues()[Tags.ValidationPostcode] as AnyObject)  
            
            var insuranceData = ""
            
            if (defaults.object(forKey: "insurance_status") as AnyObject).classForCoder == NSString.classForCoder(){
                insuranceData = "0"
            }else{
                
                if isWantInsurance{
                    if agreeTerm.checkState.rawValue == 1{
                        insuranceData = "\(agreeTerm.checkState.rawValue)"
                    }
                }else{
                    insuranceData = "0"
                }
                
            }
            
            let goingSSRDict = NSMutableArray()
            let returnSSRDict = NSMutableArray()
            
            let tempDict = [AnyObject]()
            
            goingSSRDict.add(tempDict)
            returnSSRDict.add(tempDict)
            
            if insuranceData == "" {
                showErrorMessage("To proceed, you need to agree with the Insurance Declaration.")
            }else{
                
                var customer_number = String()
                
                if try! LoginManager.sharedInstance.isLogin(){
                    customer_number = defaults.object(forKey: "customer_number") as! String
                }

                showLoading()
                FireFlyProvider.request(.ContactDetail("FY",bookIdData, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signatureData, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData, "Y", goingSSRDict[0] as AnyObject, returnSSRDict[0] as AnyObject, customer_number), completion: { (result) -> () in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let chooseSeatVC = storyboard.instantiateViewController(withIdentifier: "SeatSelectionVC") as! AddSeatSelectionViewController
                                chooseSeatVC.journeys = json["journeys"].arrayObject! as [AnyObject]
                                chooseSeatVC.seatFare = json["seat_fare"].arrayObject! as [AnyObject]
                                chooseSeatVC.passenger = json["passengers"].arrayObject! as [AnyObject]
                                self.navigationController!.pushViewController(chooseSeatVC, animated: true)
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
    
    @IBAction func changeContactBtnPressed(sender: AnyObject) {
        
        if checkPassenger.checkState == M13CheckboxState.checked{
            checkPassenger.checkState = M13CheckboxState.unchecked
            
            contactData = ["address1" : "" ,
                           "address2" : "",
                           "address3" : "",
                           "alternate_phone" : "",
                           "city" : "",
                           "company_name" : "",
                           "country" : "",
                           "email" : "",
                           "first_name" : "",
                           "last_name" : "",
                           "mobile_phone" : "",
                           "postcode" : "",
                           "state" : "",
                           "title" : "",
                           "travel_purpose" : "1"]
            
            initializeForm()
            
        }else{
            checkPassenger.checkState = M13CheckboxState.checked
            getPassengerData()
            
            if isOnePassenger{
                
                let tempData = passengerData[0]
                if let userInfo = defaults.object(forKey: "userInfo") as? NSDictionary{
                    
                    if userInfo["first_name"] as! String == tempData["first_name"] as! String{
                        contactData = ["address1" : "" ,
                                       "address2" : "",
                                       "address3" : "",
                                       "alternate_phone" : "\(userInfo["contact_alternate_phone"]!)",
                                       "city" : "",
                                       "company_name" : "",
                                       "country" : "\(userInfo["contact_country"]!)",
                                       "email" : "\(userInfo["contact_email"]!)",
                                       "first_name" : "\(userInfo["first_name"]!)",
                                       "last_name" : "\(userInfo["last_name"]!)",
                                       "mobile_phone" : "\(userInfo["contact_mobile_phone"]!)",
                                       "postcode" : "",
                                       "state" : "",
                                       "title" : "\(userInfo["title"]!)",
                                       "travel_purpose" : "1"]
                    }else{
                        
                        contactData = ["address1" : "" ,
                                       "address2" : "",
                                       "address3" : "",
                                       "alternate_phone" : "",
                                       "city" : "",
                                       "company_name" : "",
                                       "country" : "\(tempData["issuing_country"]!)",
                                       "email" : "",
                                       "first_name" : "\(tempData["first_name"]!)",
                                       "last_name" : "\(tempData["last_name"]!)",
                                       "mobile_phone" : "",
                                       "postcode" : "",
                                       "state" : "",
                                       "title" : "\(tempData["title"]!)",
                                       "travel_purpose" : "1"]
                        
                    }
                    
                }else{
                    
                    contactData = ["address1" : "" ,
                                   "address2" : "",
                                   "address3" : "",
                                   "alternate_phone" : "",
                                   "city" : "",
                                   "company_name" : "",
                                   "country" : "\(tempData["issuing_country"]!)",
                                   "email" : "",
                                   "first_name" : "\(tempData["first_name"]!)",
                                   "last_name" : "\(tempData["last_name"]!)",
                                   "mobile_phone" : "",
                                   "postcode" : "",
                                   "state" : "",
                                   "title" : "\(tempData["title"]!)",
                                   "travel_purpose" : "1"]
                    
                }
                initializeForm()
                
            }else{
                let picker = ActionSheetStringPicker(title: "", rows: passengerArray, initialSelection: passengerSelected, target: self, successAction: #selector(AddContactDetailViewController.objectSelected(_:element:)), cancelAction: #selector(self.actionSheetCancel(_:)), origin: sender)
                picker?.show()
            }
            
            
        }
        
    }
    
    var passengerSelected = Int()
    var passengerData = [NSDictionary]()
    var passengerArray = [String]()
    
    func getPassengerData(){
        if let passenger = defaults.object(forKey: "passengerData") as? NSDictionary{
            passengerData = [NSDictionary]()
            passengerArray = [String]()
            for (_, data) in passenger{
                
                let passengerInfo = data as! NSDictionary
                let name = "\(getTitleName(passengerInfo["title"] as! String)) \(passengerInfo["first_name"]!) \(passengerInfo["last_name"]!)"
                
                passengerArray.append(name)
                passengerData.append(passengerInfo)
            }
        }
    }
    
    func objectSelected(_ index :NSNumber, element:AnyObject){
        
        let tempData = passengerData[Int(index)]
        
        if let userInfo = defaults.object(forKey: "userInfo") as? NSDictionary{
            
            if userInfo["first_name"] as! String == tempData["first_name"] as! String{
                contactData = ["address1" : "" ,
                               "address2" : "",
                               "address3" : "",
                               "alternate_phone" : "\(userInfo["contact_alternate_phone"]!)",
                               "city" : "",
                               "company_name" : "",
                               "country" : "\(userInfo["contact_country"]!)",
                               "email" : "\(userInfo["contact_email"]!)",
                               "first_name" : "\(userInfo["first_name"]!)",
                               "last_name" : "\(userInfo["last_name"]!)",
                               "mobile_phone" : "\(userInfo["contact_mobile_phone"]!)",
                               "postcode" : "",
                               "state" : "",
                               "title" : "\(userInfo["title"]!)",
                               "travel_purpose" : "1"]
            }else{
                
                contactData = ["address1" : "" ,
                               "address2" : "",
                               "address3" : "",
                               "alternate_phone" : "",
                               "city" : "",
                               "company_name" : "",
                               "country" : "\(tempData["issuing_country"]!)",
                               "email" : "",
                               "first_name" : "\(tempData["first_name"]!)",
                               "last_name" : "\(tempData["last_name"]!)",
                               "mobile_phone" : "",
                               "postcode" : "",
                               "state" : "",
                               "title" : "\(tempData["title"]!)",
                               "travel_purpose" : "1"]
                
            }
            
        }else{
            
            contactData = ["address1" : "" ,
                           "address2" : "",
                           "address3" : "",
                           "alternate_phone" : "",
                           "city" : "",
                           "company_name" : "",
                           "country" : "\(tempData["issuing_country"]!)",
                           "email" : "",
                           "first_name" : "\(tempData["first_name"]!)",
                           "last_name" : "\(tempData["last_name"]!)",
                           "mobile_phone" : "",
                           "postcode" : "",
                           "state" : "",
                           "title" : "\(tempData["title"]!)",
                           "travel_purpose" : "1"]
            
        }
        initializeForm()
    }
    
    @IBAction func yesBtnPressed(_ sender: AnyObject) {
        isWantInsurance = true
        insuranceView.isHidden = true
        views.isHidden = false
        var newFrame = footerView.bounds
        newFrame.size.height = 765
        
        footerView.frame = newFrame
        self.tableView.tableFooterView = footerView
        
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
