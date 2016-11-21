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
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateInformationViewController.selectCountry(_:)), name: NSNotification.Name(rawValue: "selectCountry"), object: nil)
        stateArray = defaults.object(forKey: "state") as! [Dictionary<String, AnyObject>]
        initializeForm()
        
        AnalyticsManager.sharedInstance.logScreen(GAConstants.updateInformationScreen)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        userInfo = defaults.object(forKey: "userInfo") as! NSMutableDictionary
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSection(withTitle: "LabelLogin".localized)
        form.addFormSection(section)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Email:*")
        row.value = userInfo["username"]
        row.disabled = true
        row.isRequired = true
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
        row.isRequired = true
        section.addFormRow(row)
        
        // First Name/Given Name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        row.isRequired = true
        row.value = userInfo["contact_first_name"]
        section.addFormRow(row)
        
        // Last Name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        row.isRequired = true
        row.value = userInfo["contact_last_name"]
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
        
        let date = userInfo["DOB"] as! String
        let arrangeDate = date.components(separatedBy: "-")

        row.value = "\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])"
        row.isRequired = true
        section.addFormRow(row)
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelAddress".localized
        form.addFormSection(section)
        
        
        // Address Line 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 1:*")
        row.isRequired = true
        row.value = (userInfo["contact_address1"] as! String).xmlSimpleUnescape()
        section.addFormRow(row)
        
        // Address Line 2
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine2, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 2:")
        row.value = (userInfo["contact_address2"] as! String).xmlSimpleUnescape()
        section.addFormRow(row)
        
        // Address Line 3
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine3, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 3:")
        row.value = (userInfo["contact_address3"] as! String).xmlSimpleUnescape()
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
        row.isRequired = true
        section.addFormRow(row)
        
        // Town/City
        row = XLFormRowDescriptor(tag: Tags.ValidationTownCity, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Town / City:*")
        row.isRequired = true
        row.value = (userInfo["contact_city"] as! String).xmlSimpleUnescape()
        section.addFormRow(row)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"State:*")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.isRequired = true
        section.addFormRow(row)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Postcode:*")
        row.isRequired = true
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
        let state = defaults.object(forKey: "state") as! [Dictionary<String,AnyObject>]
        
        for stateData in state{
            if stateData["country_code"] as! String == userInfo["contact_country"] as! String{
                stateArr.append(stateData as NSDictionary)
            }
        }
        
        self.form.removeFormRow(withTag: Tags.ValidationState)
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
        row.isRequired = true
        
        self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        
    }
    
    func selectCountry(_ sender:NSNotification){
        
        country(countryCode: sender.userInfo!["countryVal"]! as! String)
        dialCode = sender.userInfo!["dialingCode"]! as! String
        
        var row : XLFormRowDescriptor
        self.form.removeFormRow(withTag: Tags.ValidationMobileHome)
        
        if userInfo["contact_country"] as? String != sender.userInfo!["countryVal"]! as? String{
            
            // Mobile Number
            row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile / Home:")
            row.addValidator(XLFormRegexValidator(msg: "Mobile phone must start with country code and not less than 7 digits.", andRegexString: "^\(dialCode)[0-9]{7,}$"))
            row.value = dialCode
            self.form.addFormRow(row, beforeRowTag: Tags.ValidationAlternate)//(row, afterRowTag: Tags.ValidationPostcode)
            
            self.form.removeFormRow(withTag: Tags.ValidationAlternate)
            self.form.removeFormRow(withTag: Tags.ValidationFax)
            
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
            
            self.form.removeFormRow(withTag: Tags.ValidationAlternate)
            self.form.removeFormRow(withTag: Tags.ValidationFax)
            
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
            
            self.form.removeFormRow(withTag: Tags.ValidationState)
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
            row.isRequired = true
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            return 55
        }else{
            return 35
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = Bundle.main.loadNibNamed("SectionView", owner: self, options: nil)?[0] as! SectionView
        
        if section != 0{
            sectionView.changePassLbl.isHidden = true
        }
        
        sectionView.bgView.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        sectionView.sectionLbl.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSection(at: index)?.title
        sectionView.sectionLbl.textColor = UIColor.white
        sectionView.sectionLbl.textAlignment = NSTextAlignment.center
        
        return sectionView
    }
    
    @IBAction func continueButtonPressed(_ sender: AnyObject) {
        
        validateForm()
        
        if isValidate {
            let currentDate: Date = Date()
            var calendar: Calendar = Calendar(identifier: .gregorian) //(identifier: NSCalendar.Identifier.gregorian)!
            calendar.timeZone = TimeZone(identifier: "UTC")!
            
            var components: DateComponents = DateComponents()
            components.calendar = calendar
            
            components.year = -18
            let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
                //.dateByAddingComponents(components, toDate: currentDate, options: NSCalendar.Options(rawValue: 0))!
            
            let date = formValues()[Tags.ValidationDate]! as! String
            let arrangeDate = date.components(separatedBy: "-")
            
            let selectDate: Date = stringToDate(date)
            
            if nullIfEmpty(formValues()[Tags.ValidationPassword] as AnyObject) != ""{
                
                if nullIfEmpty(formValues()[Tags.ValidationNewPassword] as AnyObject) == ""{
                    
                    let index = form.indexPath(ofFormRow: form.formRow(withTag: Tags.ValidationNewPassword)!)! as IndexPath
                    let cell = self.tableView.cellForRow(at: index) as! CustomFloatLabelCell
                    
                    let msg = String(format: "%@ can't be empty", Tags.ValidationNewPassword)
                    
                    let textFieldAttrib = NSAttributedString.init(string: msg, attributes: [NSForegroundColorAttributeName : UIColor.red])
                    cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                    showErrorMessage(msg)
                    
                }else if nullIfEmpty(formValues()[Tags.ValidationConfirmPassword] as AnyObject) == ""{
                    
                    let index = form.indexPath(ofFormRow: form.formRow(withTag: Tags.ValidationConfirmPassword)!)! as IndexPath
                    let cell = self.tableView.cellForRow(at: index) as! CustomFloatLabelCell
                    
                    let msg = String(format: "%@ can't be empty", Tags.ValidationConfirmPassword)
                    
                    let textFieldAttrib = NSAttributedString.init(string: msg, attributes: [NSForegroundColorAttributeName : UIColor.red])
                    cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                    showErrorMessage(msg)
                    
                }else if nullIfEmpty(formValues()[Tags.ValidationNewPassword] as AnyObject) == nullIfEmpty(formValues()[Tags.ValidationConfirmPassword] as AnyObject){
                    
                    let dec = try! EncryptManager.sharedInstance.aesDecrypt(userInfo["password"] as! String, key: key, iv: iv)
                    
                    if nullIfEmpty(formValues()[Tags.ValidationPassword] as AnyObject) == dec{
                        
                        sendInfo()
                        
                    }else{
                        showErrorMessage("Current password is incorrect")
                    }
                    
                }else{
                    showErrorMessage("Confirm password is incorrect")
                }
                
            }else if minDate.compare(selectDate) == ComparisonResult.orderedAscending {
                showErrorMessage("User must age 18 and above to register")
            }else {
                sendInfo()
            }
        }
    }
    
    func sendInfo(){
        var encOldPassword = String()
        var encNewPassword = String()
        
        if nullIfEmpty(formValues()[Tags.ValidationPassword] as AnyObject) != ""{
            encOldPassword = try! EncryptManager.sharedInstance.aesEncrypt(nullIfEmpty(formValues()[Tags.ValidationPassword]! as AnyObject?), key: key, iv: iv)
            
            encNewPassword = try! EncryptManager.sharedInstance.aesEncrypt(nullIfEmpty(formValues()[Tags.ValidationNewPassword]! as AnyObject?), key: key, iv: iv)
        }else{
            encOldPassword = ""
            encNewPassword = ""
        }
        
        let date = formValues()[Tags.ValidationDate]! as! String
        let arrangeDate = date.components(separatedBy: "-")
        
        let selectDate: Date = stringToDate(date)
        
        let username = userInfo["username"]! as! String
        let password = encOldPassword
        let newPassword = encNewPassword
        let title = getTitleCode(formValues()[Tags.ValidationTitle] as! String, titleArr: titleArray)
        let firstName = formValues()[Tags.ValidationFirstName]! as! String
        let lastName = formValues()[Tags.ValidationLastName]! as! String
        let dob = formatDate(selectDate)
        let address1 = (formValues()[Tags.ValidationAddressLine1]! as! String).xmlSimpleEscape()
        let address2 = nullIfEmpty(formValues()[Tags.ValidationAddressLine2] as AnyObject).xmlSimpleEscape()
        let address3 = nullIfEmpty(formValues()[Tags.ValidationAddressLine3] as AnyObject).xmlSimpleEscape()
        let country = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
        let city = (formValues()[Tags.ValidationTownCity] as! String!).xmlSimpleEscape()
        let state = getStateCode(formValues()[Tags.ValidationState]! as! String, stateArr: stateArray)
        let postcode = formValues()[Tags.ValidationPostcode]! as! String
        let mobilePhone = nullIfEmpty(formValues()[Tags.ValidationMobileHome]! as AnyObject)
        let alternatePhone = nullIfEmpty(formValues()[Tags.ValidationAlternate] as AnyObject)
        let fax = nullIfEmpty(formValues()[Tags.ValidationFax] as AnyObject)
        let bonuslink = nullIfEmpty(formValues()[Tags.ValidationEnrichLoyaltyNo] as AnyObject)
        let signature = defaults.object(forKey: "signatureLoad")! as! String
        let newsletter = userInfo["newsletter"] as! String
        
        showLoading()
        FireFlyProvider.request(.UpdateUserProfile(username, password, newPassword, title, firstName, lastName, dob, address1!, address2!, address3!, country, city!, state, postcode, mobilePhone, alternatePhone, fax, bonuslink, signature, newsletter), completion: { (result) -> () in
            
            switch result {
            case .success(let successResult):
                do {
                    let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                    
                    if json["status"] == "success"{
                        showToastMessage("Information successfully updated")
                        defaults.set(json["user_info"].dictionaryObject, forKey: "userInfo")
                        defaults.synchronize()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadSideMenu"), object: nil)
                        
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
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
                
            case .failure(let failureResult):
                
                hideLoading()
                showErrorMessage(failureResult.localizedDescription)
                
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
