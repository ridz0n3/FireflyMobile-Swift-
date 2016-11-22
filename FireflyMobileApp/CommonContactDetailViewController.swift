//
//  CommonContactDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON
import M13Checkbox

class CommonContactDetailViewController: BaseXLFormViewController {
    
    var stateArray = [Dictionary<String,AnyObject>]()
    var contactData = Dictionary<String,String>()
    
    @IBOutlet weak var insuranceView: UIView!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var paragraph1: UITextView!
    @IBOutlet weak var paragraph2: UITextView!
    @IBOutlet weak var paragraph3: UILabel!
    @IBOutlet weak var agreeTerm: M13Checkbox!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    var titleArray = defaults.object(forKey: "title") as! [Dictionary<String,AnyObject>]
    var countryArray = defaults.object(forKey: "country") as! [Dictionary<String,AnyObject>]
    var flightType = String()
    var meals = [AnyObject]()
    var ssrStatus = String()
    
    override func viewDidLoad() {
        
        agreeTerm.strokeColor = UIColor.orange
        agreeTerm.checkColor = UIColor.orange
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        super.viewDidLoad()
        setupLeftButton()
        stateArray = defaults.object(forKey: "state") as! [Dictionary<String,AnyObject>]
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(CommonContactDetailViewController.addBusiness(_:)), name: NSNotification.Name(rawValue: "addBusiness"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommonContactDetailViewController.removeBusiness(_:)), name: NSNotification.Name(rawValue: "removeBusiness"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommonContactDetailViewController.selectCountry(_:)), name: NSNotification.Name(rawValue: "selectCountry"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        if flightType == "MH" && ssrStatus == "Available"{
            
            let timeDifference = defaults.object(forKey: "timeDifference") as! Int
            
            if timeDifference > 0{
                section = XLFormSectionDescriptor()
                section = XLFormSectionDescriptor.formSection(withTitle: "SPECIAL MEALS REQUEST")
                form.addFormSection(section)
                
                var i = 0
                for mealInfo in meals{
                    
                    section = XLFormSectionDescriptor()
                    section = XLFormSectionDescriptor.formSection(withTitle: mealInfo["destination_name"] as? String)
                    form.addFormSection(section)
                    
                    let mealList = mealInfo["list_meal"] as! [AnyObject]
                    let passengerList = mealInfo["passenger"] as! [AnyObject]
                    
                    for passengerInfo in passengerList{
                        
                        // Meals
                        row = XLFormRowDescriptor(tag: "\(Tags.ValidationSSRList)(\(i)\(passengerInfo["passenger_number"] as! Int))", rowType:XLFormRowDescriptorTypeFloatLabeled, title:passengerInfo["name"] as? String)
                        
                        var tempArray:[AnyObject] = [AnyObject]()
                        for mealsDetail in mealList{
                            tempArray.append(XLFormOptionsObject(value: mealsDetail["meal_code"] as! String, displayText: mealsDetail["name"] as! String))
                            
                            if mealsDetail["meal_code"] as! String == ""{
                                row.value = mealsDetail["name"] as! String
                            }
                        }
                        
                        row.selectorOptions = tempArray
                        section.addFormRow(row)
                        
                    }
                    i += 1
                }
            }
        }
        
        
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSection(withTitle: "CONTACT DETAIL")
        form.addFormSection(section)
        
        // Purpose
        row = XLFormRowDescriptor(tag: Tags.ValidationPurpose, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Primary Purpose of Your Trip:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for purpose in purposeArray {
            tempArray.append(XLFormOptionsObject(value: purpose["purpose_code"], displayText: purpose["purpose_name"]!))
            
            if contactData["travel_purpose"]! == purpose["purpose_code"]!{
                row.value = purpose["purpose_name"]
            }
        }
        
        row.selectorOptions = tempArray
        row.isRequired = true
        section.addFormRow(row)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
        
        tempArray = [AnyObject]()
        for title in titleArray {
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as? String))
            
            if contactData["title"]! == title["title_code"] as? String{
                row.value = title["title_name"]
            }
        }
        
        row.selectorOptions = tempArray
        row.isRequired = true
        section.addFormRow(row)
        
        //first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.isRequired = true
        row.value = contactData["first_name"]
        section.addFormRow(row)
        
        //last name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.isRequired = true
        row.value = contactData["last_name"]
        section.addFormRow(row)
        
        //email
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Email Address:*")
        row.isRequired = true
        row.value = contactData["email"]
        row.addValidator(XLFormValidator.email())
        section.addFormRow(row)
        
        var dialCode = String()
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Country:*")
        
        tempArray = [AnyObject]()
        
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            
            if contactData["country"]! == country["country_code"]  as? String{
                row.value = country["country_name"]
                dialCode = country["dialing_code"] as! String
            }
        }
        
        row.selectorOptions = tempArray
        row.isRequired = true
        section.addFormRow(row)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile Number:*")
        row.isRequired = true
        row.addValidator(XLFormRegexValidator(msg: "Mobile phone must start with country code and not less than 7 digits.", andRegexString: "^\(dialCode)[0-9]{7,}$"))
        //row.value = contactData["mobile_phone"]
        if contactData["mobile_phone"]! == ""{
            row.value = dialCode
        }else{
            row.value = contactData["mobile_phone"]!
        }
        section.addFormRow(row)
        
        // Alternate Number
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Alternate Number:*")
        row.addValidator(XLFormRegexValidator(msg: "Alternate phone must start with country code and not less than 7 digits.", andRegexString: "^\(dialCode)[0-9]{7,}$"))
        row.isRequired = true
        //row.value = contactData["alternate_phone"]
        if contactData["alternate_phone"]! == ""{
            row.value = dialCode
        }else{
            row.value = contactData["alternate_phone"]!
        }
        section.addFormRow(row)
        
        self.form = form
        
        if contactData["travel_purpose"]! == "2"{
            addBusinessRow()
        }
    }
    
    func getPurpose(_ purposeName:String, purposeArr:[Dictionary<String,AnyObject>]) -> String{
        
        var purposeCode = String()
        for purposeData in purposeArr{
            if purposeData["purpose_name"] as! String == purposeName{
                purposeCode = purposeData["purpose_code"] as! String
            }
        }
        return purposeCode
    }
    
    func addBusiness(_ sender:NSNotification){
        addBusinessRow()
    }
    
    func addBusinessRow(){
        var row : XLFormRowDescriptor
        
        // Company Name
        row = XLFormRowDescriptor(tag: Tags.ValidationCompanyName, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Company Name:*")
        row.isRequired = true
        row.value = nilIfEmpty(contactData["company_name"] as AnyObject).xmlSimpleUnescape()
        self.form.addFormRow(row, afterRowTag: Tags.ValidationEmail)
        
        // Address 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Address 1:*")
        row.isRequired = true
        row.value = nilIfEmpty(contactData["address1"] as AnyObject).xmlSimpleUnescape()
        self.form.addFormRow(row, afterRowTag: Tags.ValidationCompanyName)
        
        // Address 2
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine2, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Address 2:*")
        row.isRequired = true
        row.value = nilIfEmpty(contactData["address2"] as AnyObject?).xmlSimpleUnescape()
        self.form.addFormRow(row, afterRowTag: Tags.ValidationAddressLine1)
        
        // Address 3
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine3, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Address 3:*")
        row.isRequired = true
        row.value = nilIfEmpty(contactData["address3"] as AnyObject?).xmlSimpleUnescape()
        self.form.addFormRow(row, afterRowTag: Tags.ValidationAddressLine2)
        
        // City
        row = XLFormRowDescriptor(tag: Tags.ValidationTownCity, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"City:*")
        row.isRequired = true
        row.value = nilIfEmpty(contactData["city"] as AnyObject?).xmlSimpleUnescape()
        self.form.addFormRow(row, afterRowTag: Tags.ValidationCountry)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"State:*")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.value = contactData["state"]
        row.isRequired = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Postcode:*")
        row.isRequired = true
        row.value = contactData["postcode"]
        self.form.addFormRow(row, afterRowTag: Tags.ValidationState)
        
        if nullIfEmpty(self.formValues()["Country"]! as AnyObject?) != ""{
            country(getCountryCode(self.formValues()["Country"]! as! String, countryArr: countryArray))
        }
    }
    
    func removeBusiness(_ sender:NSNotification){
        
        self.form.removeFormRow(withTag: Tags.ValidationCompanyName)
        self.form.removeFormRow(withTag: Tags.ValidationAddressLine1)
        self.form.removeFormRow(withTag: Tags.ValidationAddressLine2)
        self.form.removeFormRow(withTag: Tags.ValidationAddressLine3)
        self.form.removeFormRow(withTag: Tags.ValidationTownCity)
        self.form.removeFormRow(withTag: Tags.ValidationState)
        self.form.removeFormRow(withTag: Tags.ValidationPostcode)
        
    }
    
    var dialingCode = String()
    
    func selectCountry(_ sender:NSNotification){
        country(sender.userInfo!["countryVal"]! as! String)
        
        self.form.removeFormRow(withTag: Tags.ValidationMobileHome)
        self.form.removeFormRow(withTag: Tags.ValidationAlternate)
        
        var row : XLFormRowDescriptor
        
        if contactData["country"]! != sender.userInfo!["countryVal"]! as? String{
            
            // Mobile Number
            row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile Number:*")
            row.isRequired = true
            row.addValidator(XLFormRegexValidator(msg: "Mobile phone must start with country code and not less than 7 digits.", andRegexString: "^\(sender.userInfo!["dialingCode"]! as! String)[0-9]{7,}$"))
            row.value = sender.userInfo!["dialingCode"]! as! String
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationCountry)
            
            // Alternate Number
            row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Alternate Number:*")
            row.addValidator(XLFormRegexValidator(msg: "Alternate phone must start with country code and not less than 7 digits.", andRegexString: "^\(sender.userInfo!["dialingCode"]! as! String)[0-9]{7,}$"))
            row.isRequired = true
            row.value = sender.userInfo!["dialingCode"]! as! String
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationMobileHome)
            
        }else{
            
            // Mobile Number
            row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile Number:*")
            row.isRequired = true
            row.addValidator(XLFormRegexValidator(msg: "Mobile phone must not less than 7 digits.", andRegexString: "^\(sender.userInfo!["dialingCode"]! as! String)[0-9]{7,}$"))
            
            if contactData["mobile_phone"]! == ""{
                row.value = sender.userInfo!["dialingCode"]! as! String
            }else{
                row.value = contactData["mobile_phone"]!
            }
            self.form.addFormRow(row, afterRowTag: Tags.ValidationCountry)
            
            // Alternate Number
            row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Alternate Number:*")
            row.addValidator(XLFormRegexValidator(msg: "Alternate phone must not less than 7 digits.", andRegexString: "^\(sender.userInfo!["dialingCode"]! as! String)[0-9]{7,}$"))
            row.isRequired = true
            
            if contactData["alternate_phone"]! == ""{
                row.value = sender.userInfo!["dialingCode"]! as! String
            }else{
                row.value = contactData["alternate_phone"]!
            }
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationMobileHome)
            
        }
    }
    
    func country(_ countryCode:String){
        if self.formValues()[Tags.ValidationState] != nil{
            var stateArr = [NSDictionary]()
            for stateData in stateArray{
                if stateData["country_code"] as! String == countryCode{
                    stateArr.append(stateData as NSDictionary)
                }
            }
            
            self.form.removeFormRow(withTag: Tags.ValidationState)
            var row : XLFormRowDescriptor
            row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"State:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            if stateArr.count != 0{
                for data in stateArr{
                    tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
                    
                    
                    if nilIfEmpty(contactData["state"] as AnyObject?) == data["state_code"] as! String{
                        row.value = data["state_name"]
                    }
                }
            }
            else {
                
                if nilIfEmpty(contactData["state"] as AnyObject?) == "OT"{
                    row.value = "Others"
                }
                
                tempArray.append(XLFormOptionsObject(value: "OT", displayText: "Other"))
            }
            
            row.selectorOptions = tempArray
            row.isRequired = true
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if flightType == "MH"{
            
            if meals.count == 2{
                if section == 1 || section == 2{
                    return UITableViewAutomaticDimension
                    
                }else{
                    return 35
                }
                
            }else{
                if section == 1{
                    return UITableViewAutomaticDimension
                    
                }else{
                    return 35
                }
            }
            
        }else{
            return 35
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = Bundle.main.loadNibNamed("PassengerHeader", owner: self, options: nil)?[0] as! PassengerHeaderView
        
        let index = UInt(section)
        sectionView.sectionLbl.text = form.formSection(at: index)?.title
        
        if flightType == "MH"{
            
            if meals.count == 2{
                if index == 1 || index == 2{
                    sectionView.views.backgroundColor = UIColor.white
                    sectionView.sectionLbl.textColor = UIColor.black
                    sectionView.sectionLbl.font = UIFont.boldSystemFont(ofSize: 12.0)
                    sectionView.sectionLbl.textAlignment = NSTextAlignment.left
                    
                }else{
                    sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                    sectionView.sectionLbl.textColor = UIColor.white
                    sectionView.sectionLbl.textAlignment = NSTextAlignment.center
                }
                
            }else{
                if index == 1{
                    sectionView.views.backgroundColor = UIColor.white
                    sectionView.sectionLbl.textColor = UIColor.black
                    sectionView.sectionLbl.font = UIFont.boldSystemFont(ofSize: 12.0)
                    sectionView.sectionLbl.textAlignment = NSTextAlignment.left
                    
                }else{
                    sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                    sectionView.sectionLbl.textColor = UIColor.white
                    sectionView.sectionLbl.textAlignment = NSTextAlignment.center
                }
            }
            
        }else{
            sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            
            sectionView.sectionLbl.textColor = UIColor.white
            sectionView.sectionLbl.textAlignment = NSTextAlignment.center
        }
        
        
        return sectionView
        
    }
    
}
