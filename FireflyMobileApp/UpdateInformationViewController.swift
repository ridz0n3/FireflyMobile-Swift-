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

class UpdateInformationViewController: BaseXLFormViewController {
    
    var userInfo = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        initializeForm()
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
        
        let star = [NSForegroundColorAttributeName : UIColor.redColor()]
        var attrString = NSMutableAttributedString()
        
        form = XLFormDescriptor(title: "")
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSectionWithTitle("Login Information")
        //section.hidden = "$\(Tags.Button1).value contains 'hide'"
        form.addFormSection(section)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeText, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Email"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Email"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.value = userInfo["username"]
        row.disabled = true
        row.required = true
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Current Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "The password must contain \n (number, symbol, uppercase, lowercase) must be no more than 16 characters in length.", andRegexString: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=-])(?=\\S+$).{8,16}$"))
        //row.required = true
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationNewPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "New Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "The password must contain \n (number, symbol, uppercase, lowercase) must be no more than 16 characters in length.", andRegexString: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=-])(?=\\S+$).{8,16}$"))
        //row.required = true
        section.addFormRow(row)
        
        // Confirm Password
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Confirm Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        //row.required = true
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "Personal Information"
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*Title")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for title in titleArray{
            
            if title["title_code"] as! String == userInfo["title"] as! String{
                row.value = XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String)
                tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
            }else{
                tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
            }
        }
        
        row.selectorOptions = tempArray
        row.cellConfigAtConfigure.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellStyle = .Value2
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        //row.title = userInfo["title"] as? String
        row.required = true
        section.addFormRow(row)
        
        // First Name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeText, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "First Name"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*First Name"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = userInfo["contact_first_name"]
        section.addFormRow(row)
        
        // Last Name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeText, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Last Name"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Last Name"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = userInfo["contact_last_name"]
        section.addFormRow(row)
        
        // Date
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let df = formater.dateFromString(userInfo["DOB"] as! String)
        
        let currentDate: NSDate = NSDate()
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(name: "UTC")!
        
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar
        
        components.year = -18
        let minDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeDate, title:"*Date of Birth")
        row.value = df
        row.cellConfigAtConfigure.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellStyle = .Value2
        row.cellConfigAtConfigure["maximumDate"] = minDate
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "dot_date")!)
        row.required = true
        section.addFormRow(row)
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section.title = "Address Information"
        //section.hidden = "$\(Tags.Button2).value contains 'hide'"
        form.addFormSection(section)
        
        
        // Address Line 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType: XLFormRowDescriptorTypeText, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Address Line 1"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Address Line 1"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = userInfo["contact_address1"]
        section.addFormRow(row)
        
        // Address Line 2
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine2, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Address Line 2"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.value = userInfo["contact_address2"]
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*Country")
        
        tempArray = [AnyObject]()
        for country in countryArray{
            
            if country["country_code"] as! String == userInfo["contact_country"] as! String{
                row.value = XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String)
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }else{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }
            
        }
        row.cellConfigAtConfigure.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellStyle = .Value2
        row.selectorOptions = tempArray
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.required = true
        section.addFormRow(row)
        
        // Town/City
        row = XLFormRowDescriptor(tag: Tags.ValidationTownCity, rowType: XLFormRowDescriptorTypeText, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Town / City"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Town / City"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = userInfo["contact_city"]
        section.addFormRow(row)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*State")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.cellConfigAtConfigure.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellStyle = .Value2
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.required = true
        section.addFormRow(row)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType: XLFormRowDescriptorTypeNumber, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Postcode"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Postcode"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = userInfo["contact_postcode"]
        section.addFormRow(row)
        
        // Contact Information - Section
        section = XLFormSectionDescriptor()
        section.title = "Contact Information"
        //section.hidden = "$\(Tags.Button3).value contains 'hide'"
        form.addFormSection(section)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypePhone, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Mobile / Home"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Mobile / Home"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "Mobile phone must not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
        row.required = true
        row.value = userInfo["contact_mobile_phone"]
        section.addFormRow(row)
        
        
        // Alternate
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypePhone, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Alternate"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Alternate"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.value = userInfo["contact_alternate_phone"]
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "Alternate phone must not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
        section.addFormRow(row)
        
        // Fax
        row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Fax"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.value = userInfo["contact_fax"]
        section.addFormRow(row)
        
        // BonusLink - Section
        section = XLFormSectionDescriptor()
        section.title = "Loyalty Programme"
        //section.hidden = "$\(Tags.Button3).value contains 'hide'"
        form.addFormSection(section)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationEnrichLoyaltyNo, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Bonuslink Card No"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
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
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*State")
        
        var tempArray:[AnyObject] = [AnyObject]()
        
        for data in stateArr{
            
            if data["state_code"] as! String == userInfo["contact_state"] as! String{
                row.value = XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String)
                tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
            }else{
                tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
            }
        }
        
        if tempArray.count == 0{
            row.value = XLFormOptionsObject(value: "OT", displayText: "Others")
            tempArray.append(XLFormOptionsObject(value: "OT", displayText: "Others"))
        }
        
        row.selectorOptions = tempArray
        row.cellConfigAtConfigure.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellStyle = .Value2
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.required = true
        
        self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = NSBundle.mainBundle().loadNibNamed("SectionView", owner: self, options: nil)[0] as! SectionView
        
        //sectionView.frame = CGRectMake(0, 0,self.view.frame.size.width, 44)
        sectionView.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
    }
    
    override func beginEditing(rowDescriptor: XLFormRowDescriptor!) {
        rowDescriptor.cellForFormController(self).unhighlight()
    }
    
    override func endEditing(rowDescriptor: XLFormRowDescriptor!) {
        rowDescriptor.cellForFormController(self).unhighlight()
        if rowDescriptor.tag == Tags.ValidationCountry{
            var stateArr = [NSDictionary]()
            let state = defaults.objectForKey("state") as! [Dictionary<String,AnyObject>]
            
            for stateData in state{
                if stateData["country_code"] as! String == (form.formRowWithTag(Tags.ValidationCountry)?.value as! XLFormOptionObject).formValue() as! String{
                    stateArr.append(stateData)
                }
            }
            
            self.form.removeFormRowWithTag(Tags.ValidationState)
            var row : XLFormRowDescriptor
            row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*State")
            
            var tempArray:[AnyObject] = [AnyObject]()
            
            if stateArr.count != 0{
                for data in stateArr{
                    tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
                }
            }else{
                tempArray.append(XLFormOptionsObject(value: "OT", displayText: "Others"))
            }
            
                row.cellConfigAtConfigure.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
                row.cellStyle = .Value2
                row.selectorOptions = tempArray
                row.value = tempArray[0]
                row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
                row.required = true
                
                self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
            
        }
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate {
            let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            calendar.timeZone = NSTimeZone(name: "UTC")!
            
            let components: NSDateComponents = NSDateComponents()
            components.calendar = calendar
            
            components.year = -18
            
            if nullIfEmpty(formValues()[Tags.ValidationPassword]) as! String != ""{
                
                if nullIfEmpty(formValues()[Tags.ValidationNewPassword]) as! String == ""{
                    
                    let index = form.indexPathOfFormRow(form.formRowWithTag(Tags.ValidationNewPassword)!)! as NSIndexPath
                    let cell = self.tableView.cellForRowAtIndexPath(index) as! XLFormTextFieldCell
                    
                    let msg = String(format: "%@ can't be empty", Tags.ValidationNewPassword)
                    
                    let textFieldAttrib = NSAttributedString.init(string: msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                    cell.textField?.attributedPlaceholder = textFieldAttrib
                    showErrorMessage(msg)
                    
                }else if nullIfEmpty(formValues()[Tags.ValidationConfirmPassword]) as! String == ""{
                    
                    let index = form.indexPathOfFormRow(form.formRowWithTag(Tags.ValidationConfirmPassword)!)! as NSIndexPath
                    let cell = self.tableView.cellForRowAtIndexPath(index) as! XLFormTextFieldCell
                    
                    let msg = String(format: "%@ can't be empty", Tags.ValidationConfirmPassword)
                    
                    let textFieldAttrib = NSAttributedString.init(string: msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                    cell.textField?.attributedPlaceholder = textFieldAttrib
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
        
        var parameters:[String:AnyObject] = [String:AnyObject]()
        
        parameters.updateValue(userInfo["username"]!, forKey: "username")
        parameters.updateValue(encOldPassword, forKey: "password")
        parameters.updateValue(encNewPassword, forKey: "new_password")
        parameters.updateValue((formValues()[Tags.ValidationTitle]! as! XLFormOptionsObject).valueData(), forKey: "title")
        parameters.updateValue(formValues()[Tags.ValidationFirstName]!, forKey: "first_name")
        parameters.updateValue(formValues()[Tags.ValidationLastName]!, forKey: "last_name")
        parameters.updateValue(formatDate(formValues()[Tags.ValidationDate]! as! NSDate), forKey: "dob")
        parameters.updateValue(formValues()[Tags.ValidationAddressLine1]!, forKey: "address_1")
        parameters.updateValue(nullIfEmpty(formValues()[Tags.ValidationAddressLine2])!, forKey: "address_2")
        parameters.updateValue("", forKey: "address_3")
        parameters.updateValue((formValues()[Tags.ValidationCountry]! as! XLFormOptionsObject).valueData(), forKey: "country")
        parameters.updateValue(formValues()[Tags.ValidationTownCity]!, forKey: "city")
        parameters.updateValue((formValues()[Tags.ValidationState]! as! XLFormOptionsObject).valueData(), forKey: "state")
        parameters.updateValue(formValues()[Tags.ValidationPostcode]!, forKey: "postcode")
        parameters.updateValue(formValues()[Tags.ValidationMobileHome]!, forKey: "mobile_phone")
        parameters.updateValue(nullIfEmpty(formValues()[Tags.ValidationAlternate])!, forKey: "alternate_phone")
        parameters.updateValue(nullIfEmpty(formValues()[Tags.ValidationFax])!, forKey: "fax")
        parameters.updateValue(nullIfEmpty(formValues()[Tags.ValidationEnrichLoyaltyNo])!, forKey: "bonuslink")
        parameters.updateValue(userInfo["signature"]!, forKey: "signature")
        parameters.updateValue(userInfo["newsletter"] as! String, forKey: "newsletter")
        
        let manager = WSDLNetworkManager()
        
        showHud("open")
        manager.sharedClient().createRequestWithService("updateProfile", withParams: parameters, completion: { (result) -> Void in
            showHud("close")
            
            if result["status"].string == "success"{
                showToastMessage("Successfully change information")
                defaults.setObject(result["user_info"].dictionaryObject, forKey: "userInfo")
                defaults.synchronize()
                
                let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                let homeVC = storyBoard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
                self.navigationController!.pushViewController(homeVC, animated: true)
            }else if result["status"].string == "error"{
                showErrorMessage(result["message"].string!)
            }else if result["status"].string == "401"{
                showErrorMessage(result["message"].string!)
                InitialLoadManager.sharedInstance.load()
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
