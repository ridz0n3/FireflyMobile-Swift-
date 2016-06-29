//
//  UpdateInformationViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/29/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import M13Checkbox
import SwiftyJSON

class UpdateInformationViewController: BaseXLFormViewController {
    
    var userInfo = NSMutableDictionary()
    var stateArray = [Dictionary<String,AnyObject>]()
    var dialCode = String()
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        setupMenuButton()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UpdateInformationViewController.selectCountry(_:)), name: "selectCountry", object: nil)
        stateArray = defaults.objectForKey("state") as! [Dictionary<String, AnyObject>]
        initializeForm()
        
        AnalyticsManager.sharedInstance.logScreen(GAConstants.updateInformationScreen)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        userInfo = defaults.objectForKey("userInfo") as! NSMutableDictionary
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSectionWithTitle("LabelLogin".localized)
        form.addFormSection(section)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Email:*")
        row.value = userInfo["username"]
        row.disabled = true
        row.required = true
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Current Password:")
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationNewPassword, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"New Password:")
        section.addFormRow(row)
        
        // Confirm Password
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmPassword, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Confirm Password")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "LabelPersonal".localized
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
        var tempArray:[AnyObject] = [AnyObject]()
        for title in titleArray{
            
            if title["title_code"] as! String == userInfo["title"] as! String{
                row.value = title["title_name"] as! String
                tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
            }else{
                tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
            }
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // First Name/Given Name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        row.required = true
        row.value = userInfo["contact_first_name"]
        section.addFormRow(row)
        
        // Last Name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        row.required = true
        row.value = userInfo["contact_last_name"]
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
        
        let date = userInfo["DOB"] as! String
        let arrangeDate = date.componentsSeparatedByString("-")

        row.value = "\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])"
        row.required = true
        section.addFormRow(row)
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelAddress".localized
        form.addFormSection(section)
        
        
        // Address Line 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 1:*")
        row.required = true
        row.value = userInfo["contact_address1"]?.xmlSimpleUnescapeString()
        section.addFormRow(row)
        
        // Address Line 2
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine2, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 2:")
        row.value = userInfo["contact_address2"]?.xmlSimpleUnescapeString()
        section.addFormRow(row)
        
        // Address Line 3
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine3, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 3:")
        row.value = userInfo["contact_address3"]?.xmlSimpleUnescapeString()
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Country:*")
        var dialingCode = String()
        
        tempArray = [AnyObject]()
        for country in countryArray{
            
            if country["country_code"] as! String == userInfo["contact_country"] as! String{
                dialingCode = country["dialing_code"] as! String
                row.value = country["country_name"] as! String
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }else{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }
            
        }
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Town/City
        row = XLFormRowDescriptor(tag: Tags.ValidationTownCity, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Town / City:*")
        row.required = true
        row.value = userInfo["contact_city"]?.xmlSimpleUnescapeString()
        section.addFormRow(row)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"State:*")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.required = true
        section.addFormRow(row)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Postcode:*")
        row.required = true
        row.value = userInfo["contact_postcode"]
        section.addFormRow(row)
        
        // Contact Information - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelContact".localized
        form.addFormSection(section)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile / Home:")
        row.addValidator(XLFormRegexValidator(msg: "Mobile must start with country code and not less than 7 digits.", andRegexString: "^\(dialingCode)[0-9]{7,}$"))
        row.value = userInfo["contact_mobile_phone"]
        section.addFormRow(row)
        
        // Alternate
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Alternate Phone:")
        row.value = userInfo["contact_alternate_phone"]
        row.addValidator(XLFormRegexValidator(msg: "Alternate must start with country code and not less than 7 digits.", andRegexString: "^\(dialingCode)[0-9]{7,}$"))
        section.addFormRow(row)
        
        // Fax
        row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Fax:")
        row.value = userInfo["contact_fax"]
        section.addFormRow(row)
        
        // BonusLink - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelLoyalty".localized
        form.addFormSection(section)
        
        // Bonuslink Number
        row = XLFormRowDescriptor(tag: Tags.ValidationEnrichLoyaltyNo, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
        row.value = userInfo["bonuslink"]
        section.addFormRow(row)
        
        
        self.form = form
        
        checkState()
    }
    
    func checkState(){
        
        var stateArr = [NSDictionary]()
        let state = defaults.objectForKey("state") as! [Dictionary<String,AnyObject>]
        
        for stateData in state{
            if stateData["country_code"] as! String == userInfo["contact_country"] as! String{
                stateArr.append(stateData as NSDictionary)
            }
        }
        
        self.form.removeFormRowWithTag(Tags.ValidationState)
        var row : XLFormRowDescriptor
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"State:*")
        var tempArray:[AnyObject] = [AnyObject]()
        for data in stateArr{
            
            if data["state_code"] as! String == userInfo["contact_state"] as! String{
                row.value = data["state_name"] as! String
                tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
            }else{
                tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
            }
        }
        
        if tempArray.count == 0{
            row.value = "Others"
            tempArray.append(XLFormOptionsObject(value: "OT", displayText: "Others"))
        }
        
        row.selectorOptions = tempArray
        row.required = true
        
        self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        
    }
    
    func selectCountry(sender:NSNotification){
        
        country(sender.userInfo!["countryVal"]! as! String)
        dialCode = sender.userInfo!["dialingCode"]! as! String
        
        var row : XLFormRowDescriptor
        self.form.removeFormRowWithTag(Tags.ValidationMobileHome)
        
        if userInfo["contact_country"] as? String != sender.userInfo!["countryVal"]! as? String{
            
            // Mobile Number
            row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile / Home:")
            row.addValidator(XLFormRegexValidator(msg: "Mobile phone must start with country code and not less than 7 digits.", andRegexString: "^\(dialCode)[0-9]{7,}$"))
            row.value = dialCode
            self.form.addFormRow(row, beforeRowTag: Tags.ValidationAlternate)//(row, afterRowTag: Tags.ValidationPostcode)
            
            self.form.removeFormRowWithTag(Tags.ValidationAlternate)
            self.form.removeFormRowWithTag(Tags.ValidationFax)
            
            // Alternate
            row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Alternate Phone:")
            row.addValidator(XLFormRegexValidator(msg: "Alternate phone must start with country code and not less than 7 digits.", andRegexString: "^\(dialCode)[0-9]{7,}$"))
            row.value = dialCode
            self.form.addFormRow(row, afterRowTag: Tags.ValidationMobileHome)
            
            // Fax
            row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Fax:")
            row.value = dialCode
            self.form.addFormRow(row, afterRowTag: Tags.ValidationAlternate)
            
        }else{
            
            // Mobile Number
            row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile / Home:")
            row.addValidator(XLFormRegexValidator(msg: "Mobile phone must start with country code and not less than 7 digits.", andRegexString: "^\(dialCode)[0-9]{7,}$"))
            
            if userInfo["contact_mobile_phone"] as! String == ""{
                row.value = dialCode
            }else{
                row.value = userInfo["contact_mobile_phone"] as! String
            }
            
            self.form.addFormRow(row, beforeRowTag: Tags.ValidationAlternate)
            
            self.form.removeFormRowWithTag(Tags.ValidationAlternate)
            self.form.removeFormRowWithTag(Tags.ValidationFax)
            
            // Alternate
            row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Alternate Phone:")
            row.addValidator(XLFormRegexValidator(msg: "Alternate phone must start with country code and not less than 7 digits.", andRegexString: "^\(dialCode)[0-9]{7,}$"))
            
            if userInfo["contact_alternate_phone"] as! String == ""{
                row.value = dialCode
            }else{
                row.value = userInfo["contact_alternate_phone"] as! String
            }
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationMobileHome)
            
            // Fax
            row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Fax:")
            
            if userInfo["contact_fax"] as! String == ""{
                row.value = dialCode
            }else{
                row.value = userInfo["contact_fax"] as! String
            }
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationAlternate)
            
        }
        
    }
    
    func country(countryCode:String){
        
        if self.formValues()[Tags.ValidationState] != nil{
            var stateArr = [NSDictionary]()
            for stateData in stateArray{
                if stateData["country_code"] as! String == countryCode{
                    stateArr.append(stateData as NSDictionary)
                }
            }
            
            self.form.removeFormRowWithTag(Tags.ValidationState)
            var row : XLFormRowDescriptor
            row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"State:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            if stateArr.count != 0{
                for data in stateArr{
                    tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
                }
            }
            else {
                tempArray.append(XLFormOptionsObject(value: "OT", displayText: "Other"))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            return 55
        }else{
            return 35
        }
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = NSBundle.mainBundle().loadNibNamed("SectionView", owner: self, options: nil)[0] as! SectionView
        
        if section != 0{
            sectionView.changePassLbl.hidden = true
        }
        
        sectionView.bgView.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        sectionView.sectionLbl.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate {
            let currentDate: NSDate = NSDate()
            let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            calendar.timeZone = NSTimeZone(name: "UTC")!
            
            let components: NSDateComponents = NSDateComponents()
            components.calendar = calendar
            
            components.year = -18
            let minDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            let date = formValues()[Tags.ValidationDate]! as! String
            let arrangeDate = date.componentsSeparatedByString("-")
            
            let selectDate: NSDate = stringToDate(date)
            
            if nullIfEmpty(formValues()[Tags.ValidationPassword]) as! String != ""{
                
                if nullIfEmpty(formValues()[Tags.ValidationNewPassword]) as! String == ""{
                    
                    let index = form.indexPathOfFormRow(form.formRowWithTag(Tags.ValidationNewPassword)!)! as NSIndexPath
                    let cell = self.tableView.cellForRowAtIndexPath(index) as! CustomFloatLabelCell
                    
                    let msg = String(format: "%@ can't be empty", Tags.ValidationNewPassword)
                    
                    let textFieldAttrib = NSAttributedString.init(string: msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                    cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                    showErrorMessage(msg)
                    
                }else if nullIfEmpty(formValues()[Tags.ValidationConfirmPassword]) as! String == ""{
                    
                    let index = form.indexPathOfFormRow(form.formRowWithTag(Tags.ValidationConfirmPassword)!)! as NSIndexPath
                    let cell = self.tableView.cellForRowAtIndexPath(index) as! CustomFloatLabelCell
                    
                    let msg = String(format: "%@ can't be empty", Tags.ValidationConfirmPassword)
                    
                    let textFieldAttrib = NSAttributedString.init(string: msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                    cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                    showErrorMessage(msg)
                    
                }else if nullIfEmpty(formValues()[Tags.ValidationNewPassword]) as! String == nullIfEmpty(formValues()[Tags.ValidationConfirmPassword]) as! String{
                    
                    let dec = try! EncryptManager.sharedInstance.aesDecrypt(userInfo["password"] as! String, key: key, iv: iv)
                    
                    if nullIfEmpty(formValues()[Tags.ValidationPassword]) as! String == dec{
                        
                        sendInfo()
                        
                    }else{
                        showErrorMessage("Current password is incorrect")
                    }
                    
                }else{
                    showErrorMessage("Confirm password is incorrect")
                }
                
            }else if minDate.compare(selectDate) == NSComparisonResult.OrderedAscending {
                showErrorMessage("User must age 18 and above to register")
            }else {
                sendInfo()
            }
        }
    }
    
    func sendInfo(){
        var encOldPassword = String()
        var encNewPassword = String()
        
        if nullIfEmpty(formValues()[Tags.ValidationPassword]) as! String != ""{
            encOldPassword = try! EncryptManager.sharedInstance.aesEncrypt(nullIfEmpty(formValues()[Tags.ValidationPassword]!) as! String, key: key, iv: iv)
            
            encNewPassword = try! EncryptManager.sharedInstance.aesEncrypt(nullIfEmpty(formValues()[Tags.ValidationNewPassword]!) as! String, key: key, iv: iv)
        }else{
            encOldPassword = ""
            encNewPassword = ""
        }
        
        let date = formValues()[Tags.ValidationDate]! as! String
        let arrangeDate = date.componentsSeparatedByString("-")
        
        let selectDate: NSDate = stringToDate(date)
        
        let username = userInfo["username"]! as! String
        let password = encOldPassword
        let newPassword = encNewPassword
        let title = getTitleCode(formValues()[Tags.ValidationTitle] as! String, titleArr: titleArray)
        let firstName = formValues()[Tags.ValidationFirstName]! as! String
        let lastName = formValues()[Tags.ValidationLastName]! as! String
        let dob = formatDate(selectDate)
        let address1 = formValues()[Tags.ValidationAddressLine1]!.xmlSimpleEscapeString()
        let address2 = nullIfEmpty(formValues()[Tags.ValidationAddressLine2])!.xmlSimpleEscapeString()
        let address3 = nullIfEmpty(formValues()[Tags.ValidationAddressLine3])!.xmlSimpleEscapeString()
        let country = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
        let city = formValues()[Tags.ValidationTownCity]!.xmlSimpleEscapeString()
        let state = getStateCode(formValues()[Tags.ValidationState]! as! String, stateArr: stateArray)
        let postcode = formValues()[Tags.ValidationPostcode]! as! String
        let mobilePhone = nullIfEmpty(formValues()[Tags.ValidationMobileHome]!) as! String
        let alternatePhone = nullIfEmpty(formValues()[Tags.ValidationAlternate])! as! String
        let fax = nullIfEmpty(formValues()[Tags.ValidationFax])! as! String
        let bonuslink = nullIfEmpty(formValues()[Tags.ValidationEnrichLoyaltyNo])! as! String
        let signature = defaults.objectForKey("signatureLoad")! as! String
        let newsletter = userInfo["newsletter"] as! String
        
        showLoading()
        FireFlyProvider.request(.UpdateUserProfile(username, password, newPassword, title, firstName, lastName, dob, address1, address2, address3, country, city, state, postcode, mobilePhone, alternatePhone, fax, bonuslink, signature, newsletter), completion: { (result) -> () in
            
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        showToastMessage("Information successfully updated")
                        defaults.setObject(json["user_info"].dictionaryObject, forKey: "userInfo")
                        defaults.synchronize()
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("reloadSideMenu", object: nil)
                        
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let homeVC = storyBoard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
                        self.navigationController!.pushViewController(homeVC, animated: true)
                    }else if json["status"] == "error"{
                        showErrorMessage(json["message"].string!)
                    }else if json["status"].string == "401"{
                        showErrorMessage(json["message"].string!)
                        InitialLoadManager.sharedInstance.load()
                    }else if json["status"].string == "error_validation"{
                        
                        var str = String()
                        for (_, value) in json["message"].dictionary!{
                            
                            str += "\(value[0])\n"
                        }
                        
                        showErrorMessage(str)
                        
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
