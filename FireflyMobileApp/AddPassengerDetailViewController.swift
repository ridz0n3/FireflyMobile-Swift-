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
import RealmSwift

class AddPassengerDetailViewController: CommonPassengerDetailViewController {
    
    var status = String()
    var isContinue = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isContinue = false
        adultArray = [Dictionary<String,AnyObject>]()
        flightType = defaults.objectForKey("flightType") as! String
        adultCount = (defaults.objectForKey("adult")?.integerValue)!
        infantCount = (defaults.objectForKey("infants")?.integerValue)!
        module = "addPassenger"
        loadFamilyAndFriendData()
        initializeForm()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.passengerDetailsScreen)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddPassengerDetailViewController.reload(_:)), name: "reloadPicker", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isContinue{
            loadFamilyAndFriendData()
            //initializeForm()
        }
        
    }
    
    func reload(sender : NSNotification){
        loadFamilyAndFriendData()
    }
    
    func loadFamilyAndFriendData(){
        
        if try! LoginManager.sharedInstance.isLogin(){
            
            let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
            let dateArr = (userInfo["DOB"] as! String).componentsSeparatedByString("-")
            var userList = Results<FamilyAndFriendList>!()
            userList = realm.objects(FamilyAndFriendList)
            let mainUser = userList.filter("email == %@",userInfo["username"] as! String)
            
            if mainUser.count != 0{
                if mainUser[0].familyList.count != 0{
                    familyAndFriendList = mainUser[0].familyList
                    rearrangeFamily()
                    self.tableView.reloadData()
                }
                
                if !isContinue{
                if familyAndFriendList.count == 0{
                    data = ["title" : userInfo["title"]!,
                            "first_name" : userInfo["first_name"]!,
                            "last_name" : userInfo["last_name"]!,
                            "dob2" : "\(dateArr[2])-\(dateArr[1])-\(dateArr[0])",
                            "issuing_country" : userInfo["contact_country"]!,
                            "bonuslink" : userInfo["bonuslink"]!,
                            "Save" : false]
                    adultInfo.updateValue(data, forKey: "0")
                }else{
                    var countExist = 0
                    for tempInfo in familyAndFriendList{
                        
                        if (tempInfo.title == userInfo["title"]! as! String) && (tempInfo.firstName == userInfo["first_name"]! as! String) && (tempInfo.lastName == userInfo["last_name"]! as! String) {
                            data = ["id" : tempInfo.id,
                                    "title" : tempInfo.title,
                                    "gender" : tempInfo.gender,
                                    "first_name" : tempInfo.firstName,
                                    "last_name" : tempInfo.lastName,
                                    "dob2" : tempInfo.dob,
                                    "issuing_country" : tempInfo.country,
                                    "bonuslink" : tempInfo.bonuslink,
                                    "type" : tempInfo.type,
                                    "Save" : false]
                            adultInfo.updateValue(data, forKey: "0")
                            countExist += 1
                        }
                    }
                    
                    if countExist == 0{
                        data = ["title" : userInfo["title"]!,
                                    "first_name" : userInfo["first_name"]!,
                                    "last_name" : userInfo["last_name"]!,
                                    "dob2" : "\(dateArr[2])-\(dateArr[1])-\(dateArr[0])",
                                    "issuing_country" : userInfo["contact_country"]!,
                                    "bonuslink" : userInfo["bonuslink"]!,
                                    "Save" : false]
                        adultInfo.updateValue(data, forKey: "0")
                    }
                }
                }
            }else{
                familyAndFriendList = nil
                rearrangeFamily()
                self.tableView.reloadData()
                data = ["title" : userInfo["title"]!,
                        "first_name" : userInfo["first_name"]!,
                        "last_name" : userInfo["last_name"]!,
                        "dob2" : "\(dateArr[2])-\(dateArr[1])-\(dateArr[0])",
                        "issuing_country" : userInfo["contact_country"]!,
                        "bonuslink" : userInfo["bonuslink"]!,
                        "Save" : false]
                adultInfo.updateValue(data, forKey: "0")
            }
        }
        
    }
    
    func rearrangeFamily(){
        infantList = [AnyObject]()
        infantName = [String]()
        
        adultList = [AnyObject]()
        adultName = [String]()
        
        if familyAndFriendList != nil{
        for familyInfo in familyAndFriendList{
            
            if familyInfo.type == "Infant"{
                infantList.append(familyInfo)
                infantName.append("\(familyInfo.firstName) \(familyInfo.lastName)".capitalizedString)
            }else{
                adultList.append(familyInfo)
                adultName.append("\(familyInfo.title) \(familyInfo.firstName) \(familyInfo.lastName)".capitalizedString)
            }
            
        }
        }
        
    }
    
    let tempData = ["id" : "",
                    "title" : "",
                    "gender" : "",
                    "first_name" : "",
                    "last_name" : "",
                    "dob2" : "",
                    "issuing_country" : "",
                    "bonuslink" : "",
                    "type" : "",
                    "Save" : false,
                    "traveling_with" : ""]
    
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
            
            if status != "select"{
                let adultData:[String:String] = ["passenger_code":"\(i)", "passenger_name":"Adult \(adult)"]
                adultArray.append(adultData)
                adultSelect.updateValue(0, forKey: "\(adult)")
            }
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("ADULT \(adult)")
            form.addFormSection(section)
            
            
            if try! LoginManager.sharedInstance.isLogin() && adult == 1 {
                
                let info = adultInfo["\(i)"]!
                // Title
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
                for title in titleArray{
                    tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
                    
                    if title["title_code"] as! String == info["title"] as! String{
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
                row.value = "\(info["first_name"]! as! String)"
                section.addFormRow(row)
                
                //last name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
                //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
                row.required = true
                row.value = "\(info["last_name"]! as! String)"
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
                row.value = formatDate(stringToDate(info["dob2"] as! String))//"\(userInfo["DOB"]!)"
                row.required = true
                section.addFormRow(row)
                
                // Country
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
                
                tempArray = [AnyObject]()
                for country in countryArray{
                    tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                    
                    if country["country_code"] as! String == info["issuing_country"] as! String{
                        row.value = country["country_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                if flightType == "FY"{
                    
                    // Enrich Loyalty No
                    row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
                    //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
                    row.value = "\(info["bonuslink"]! as! String)"
                    section.addFormRow(row)
                }
                
                if try! LoginManager.sharedInstance.isLogin() && module == "addPassenger"{
                    // Save family and friend
                    row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.SaveFamilyAndFriend, adult), rowType: XLFormRowDescriptorCheckbox, title:"Save as family & friends")
                    row.value =  [
                        CustomCheckBoxCell.kSave.status.description(): info["Save"] as! Bool
                    ]
                    section.addFormRow(row)
                }
                
            }else{
                // Title
                //
                if status != "select"{
                    adultInfo.updateValue(tempData, forKey: "\(i)")
                }
                
                let info = adultInfo["\(i)"]!
                
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
                for title in titleArray{
                    tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
                    
                    if title["title_code"] as! String == info["title"] as! String{
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
                row.value = "\(info["first_name"]! as! String)"
                section.addFormRow(row)
                
                //last name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
                //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
                row.required = true
                row.value = "\(info["last_name"]! as! String)"
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
                row.required = true
                if info["dob2"] as! String != ""{
                    row.value = formatDate(stringToDate(info["dob2"] as! String))
                }
                section.addFormRow(row)
                
                // Country
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
                
                tempArray = [AnyObject]()
                for country in countryArray{
                    tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                    
                    if country["country_code"] as! String == info["issuing_country"] as! String{
                        row.value = country["country_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                if flightType == "FY"{
                    // Enrich Loyalty No
                    row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
                    //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
                    row.value = "\(info["bonuslink"]! as! String)"
                    section.addFormRow(row)
                }
                
                if try! LoginManager.sharedInstance.isLogin() && module == "addPassenger"{
                    // Save family and friend
                    row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.SaveFamilyAndFriend, adult), rowType: XLFormRowDescriptorCheckbox, title:"Save as family & friends")
                    row.value =  [
                        CustomCheckBoxCell.kSave.status.description(): info["Save"] as! Bool
                    ]
                    section.addFormRow(row)
                }
                
            }
            
        }
        
        for i in 0..<infantCount{
            var j = i
            j = j + 1
            
            if status != "select"{
                infantSelect.updateValue(0, forKey: "\(j)")
                infantInfo.updateValue(tempData, forKey: "\(j)")
            }
            
            let info = infantInfo["\(j)"]!
            
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("INFANT \(j)")
            form.addFormSection(section)
            
            // Title
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelWith, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Traveling with:*")
            row.value = adultArray[i]["passenger_name"] as! String
            var tempArray:[AnyObject] = [AnyObject]()
            for passenger in adultArray{
                tempArray.append(XLFormOptionsObject(value: passenger["passenger_code"], displayText: passenger["passenger_name"] as! String))
                
                if passenger["passenger_code"] as! String == info["traveling_with"] as! String{
                    row.value = passenger["passenger_name"] as! String
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Gender
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationGender, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Gender:*")
            
            tempArray = [AnyObject]()
            for gender in genderArray{
                tempArray.append(XLFormOptionsObject(value: gender["gender_code"] as! String, displayText: gender["gender_name"] as! String))
                
                if gender["gender_code"] as! String == info["gender"] as! String{
                    row.value = gender["gender_name"] as! String
                }
                
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // First name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationFirstName, j), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
            //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
            row.required = true
            row.value = info["first_name"] as! String
            section.addFormRow(row)
            
            // Last Name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationLastName, j), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
            //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
            row.required = true
            row.value = info["last_name"] as! String
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDate, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
            row.required = true
            if info["dob2"] as! String != ""{
                row.value = formatDate(stringToDate(info["dob2"] as! String))
            }
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationCountry, j), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Nationality:*")
            
            tempArray = [AnyObject]()
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                
                if country["country_code"] as! String == info["issuing_country"] as! String{
                    row.value = country["country_name"] as! String
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            if try! LoginManager.sharedInstance.isLogin() && module == "addPassenger"{
                // Save family and friend
                row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.SaveFamilyAndFriend, j), rowType: XLFormRowDescriptorCheckbox, title:"Save as family & friends")
                row.value =  [
                    CustomCheckBoxCell.kSave.status.description(): info["Save"] as! Bool
                ]
                section.addFormRow(row)
            }
        }
        
        self.form = form
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        validateForm()
        isContinue = true
        if isValidate{
            let params = getFormData()
            
            if params.4{
                showErrorMessage("Passenger name is duplicated.")
            }else if !params.5 && params.1.count != 0{
                showErrorMessage("You can only assign one infant to one guest.")
            }else{
                var email = String()
                
                if try! LoginManager.sharedInstance.isLogin(){
                    let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
                    email = userInfo["contact_email"] as! String
                }
                
                showLoading()
                FireFlyProvider.request(.PassengerDetail(params.0,params.1,params.2, params.3, flightType, email), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                if try! LoginManager.sharedInstance.isLogin(){
                                    self.saveFamilyAndFriends(json["family_and_friend"].arrayObject!)
                                }
                                if json["insurance"].dictionaryValue["status"]!.string == "N"{
                                    defaults.setObject("", forKey: "insurance_status")
                                }else{
                                    defaults.setObject(json["insurance"].object, forKey: "insurance_status")
                                    defaults.synchronize()
                                }
                                
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let contactDetailVC = storyboard.instantiateViewControllerWithIdentifier("ContactDetailVC") as! AddContactDetailViewController
                                if let ssrStatus = json["ssr_status"].string{
                                    contactDetailVC.ssrStatus = ssrStatus
                                }
                                
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
    
    override func adultSelected(index: NSNumber, element: AnyObject) {
        status = "select"
        let btn = element as! UIButton
        adultSelect.updateValue(Int(index), forKey: "\(btn.tag)")
        let tempInfo = adultList[Int(index)] as! FamilyAndFriendData
        data = ["id" : tempInfo.id,
                "title" : tempInfo.title,
                "gender" : tempInfo.gender,
                "first_name" : tempInfo.firstName,
                "last_name" : tempInfo.lastName,
                "dob2" : tempInfo.dob,
                "issuing_country" : tempInfo.country,
                "bonuslink" : tempInfo.bonuslink,
                "type" : tempInfo.type,
                "Save" : false]
        adultInfo.updateValue(data, forKey: "\(btn.tag - 1)")
        initializeForm()
    }
    
    override func infantSelected(index: NSNumber, element: AnyObject) {
        status = "select"
        let btn = element as! UIButton
        infantSelect.updateValue(Int(index), forKey: "\(btn.tag)")
        let tempInfo = infantList[Int(index)] as! FamilyAndFriendData
        data = ["id" : tempInfo.id,
                "title" : tempInfo.title,
                "gender" : tempInfo.gender,
                "first_name" : tempInfo.firstName,
                "last_name" : tempInfo.lastName,
                "dob2" : tempInfo.dob,
                "issuing_country" : tempInfo.country,
                "bonuslink" : tempInfo.bonuslink,
                "type" : tempInfo.type,
                "traveling_with" : "",
                "Save" : false]
        infantInfo.updateValue(data, forKey: "\(btn.tag)")
        initializeForm()
    }
    
}
