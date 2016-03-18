//
//  RegisterPersonalInfoViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import M13Checkbox

class RegisterPersonalInfoViewController: BaseXLFormViewController {

    @IBOutlet weak var termCheckBox: M13Checkbox!
    @IBOutlet weak var promotionCheckBox: M13Checkbox!
    var fromLogin = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.lvlHeaderImg.image = UIImage(named: "registerLvl1")
        if fromLogin{
            setupLeftButton()
        }else{
            setupMenuButton()
        }
        
        
        initializeForm()
        // Do any additional setup after loading the view.
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
        
        let star = [NSForegroundColorAttributeName : UIColor.redColor()]
        let text = [NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        var attrString = NSMutableAttributedString()
        var attrText = NSMutableAttributedString()
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSectionWithTitle("Basic Information")
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
        row.required = true
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Password"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "Password must be at least 8 characters, no more than 16 characters, must include at least one upper case letter, one lower case letter, one numeric digit, and one non-alphanumeric. The password cannot contain a period(.) comma(,) or tilde(~).", andRegexString: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=-])(?=\\S+$).{8,16}$"))
        row.required = true
        section.addFormRow(row)
        //^(?=.*[a-zA-Z0-9])[a-zA-Z0-9][^,.~]{8,16}$
        
        // Confirm Password
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Confirm Password"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Confirm Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "Personal Information"
        //section.hidden = "$\(Tags.Button1).value contains 'hide'"
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*Title")
        
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrText = NSMutableAttributedString(string: "Title", attributes: text)
        attrString.appendAttributedString(attrText)
        row.cellConfig["textLabel.attributedText"] = attrString
        
        var tempArray:[AnyObject] = [AnyObject]()
        tempArray.append(XLFormOptionsObject(value: "", displayText: ""))
        for title in titleArray{
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.value = tempArray[0]
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.required = true
        section.addFormRow(row)
        
        // First Name/Given Name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeText, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "First Name/Given Name"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*First Name/Given Name"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.required = true
        section.addFormRow(row)
        
        // Last Name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeText, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Last Name/Family Name"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Last Name"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        section.addFormRow(row)
    
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeDate, title:"*Date of Birth")
        
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrText = NSMutableAttributedString(string: "Date of Birth", attributes: text)
        attrString.appendAttributedString(attrText)
        row.cellConfig["textLabel.attributedText"] = attrString
        
        row.value = NSDate()
        row.cellConfigAtConfigure["maximumDate"] = NSDate()
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
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
        section.addFormRow(row)
        
        // Address Line 2
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine2, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Address Line 2"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*Country")
        
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrText = NSMutableAttributedString(string: "Country", attributes: text)
        attrString.appendAttributedString(attrText)
        row.cellConfig["textLabel.attributedText"] = attrString
        
        tempArray = [AnyObject]()
        tempArray.append(XLFormOptionsObject(value: "", displayText: ""))
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.value = tempArray[0]
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
        section.addFormRow(row)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*State")
        
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrText = NSMutableAttributedString(string: "State", attributes: text)
        attrString.appendAttributedString(attrText)
        row.cellConfig["textLabel.attributedText"] = attrString
        
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.value = XLFormOptionsObject(value: "", displayText:"")
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.required = true
        section.addFormRow(row)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType: XLFormRowDescriptorTypePhone, title:"")
        attrString = NSMutableAttributedString(string: "*", attributes: star)
        attrString.appendAttributedString(NSAttributedString(string: "Postcode"))
        row.cellConfigAtConfigure["textField.attributedPlaceholder"] = attrString
        //row.cellConfigAtConfigure["textField.placeholder"] = "*Postcode"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Contact Information - Section
        section = XLFormSectionDescriptor()
        section.title = "Contact Information"
        //section.hidden = "$\(Tags.Button3).value contains 'hide'"
        form.addFormSection(section)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Mobile / Home"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "Mobile phone must not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
        //row.required = true
        section.addFormRow(row)
        
        // Alternate
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Alternate"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        //row.required = true
        row.addValidator(XLFormRegexValidator(msg: "Alternate phone must not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
        section.addFormRow(row)
        
        // Fax
        row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Fax"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        section.addFormRow(row)
        
        // BonusLink - Section
        section = XLFormSectionDescriptor()
        section.title = "Loyalty Programme"
        //section.hidden = "$\(Tags.Button3).value contains 'hide'"
        form.addFormSection(section)
        
        // BonusLink
        row = XLFormRowDescriptor(tag: Tags.ValidationEnrichLoyaltyNo, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Bonuslink Card No"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = NSBundle.mainBundle().loadNibNamed("SectionView", owner: self, options: nil)[0] as! SectionView
        sectionView.changePassLbl.hidden = true
        sectionView.backgroundColor = UIColor(patternImage: UIImage(named: "lineSection")!)
        
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title

        return sectionView
    }
    
    override func endEditing(rowDescriptor: XLFormRowDescriptor!) {
        rowDescriptor.cellForFormController(self).unhighlight()
        if rowDescriptor.tag == Tags.ValidationCountry{
            var stateArr = [NSDictionary]()
            let state = defaults.objectForKey("state") as! [Dictionary<String, AnyObject>]
            
            for stateData in state {
                if stateData["country_code"] as! String == (form.formRowWithTag(Tags.ValidationCountry)?.value as! XLFormOptionObject).formValue() as! String{
                    stateArr.append(stateData as NSDictionary)
                }
            }
            
            let star = [NSForegroundColorAttributeName : UIColor.redColor()]
            let text = [NSForegroundColorAttributeName : UIColor.lightGrayColor()]
            var attrString = NSMutableAttributedString()
            var attrText = NSMutableAttributedString()
            
            self.form.removeFormRowWithTag(Tags.ValidationState)
            var row : XLFormRowDescriptor
            row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*State")
            
            attrString = NSMutableAttributedString(string: "*", attributes: star)
            attrText = NSMutableAttributedString(string: "State", attributes: text)
            attrString.appendAttributedString(attrText)
            row.cellConfig["textLabel.attributedText"] = attrString
            
            var tempArray:[AnyObject] = [AnyObject]()
            tempArray.append(XLFormOptionsObject(value: "", displayText: ""))
            if stateArr.count != 0{
                for data in stateArr{
                    tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
                }
            }
            else {
                tempArray.append(XLFormOptionsObject(value: "OT", displayText: "Others"))
            }
            
            row.selectorOptions = tempArray
            row.value = tempArray[0]
            row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
            row.required = true
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        }
    }

    @IBAction func continueButtonPressed(sender: AnyObject) {

        validateForm()
    
        //promotionCheckBox.checkState.
        if isValidate {
            
            let currentDate: NSDate = NSDate()
            let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            calendar.timeZone = NSTimeZone(name: "UTC")!
            
            let components: NSDateComponents = NSDateComponents()
            components.calendar = calendar
            
            components.year = -18
            let minDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            
            if formValues()[Tags.ValidationPassword]! as! String != formValues()[Tags.ValidationConfirmPassword]! as! String {
            
                let index = form.indexPathOfFormRow(form.formRowWithTag(Tags.ValidationConfirmPassword)!)! as NSIndexPath
                let cell = self.tableView.cellForRowAtIndexPath(index) as! XLFormTextFieldCell
                
                animateCell(cell)
                showErrorMessage("Confirm password incorrect")
            }
			else if ((formValues()[Tags.ValidationTitle]! as! XLFormOptionsObject).valueData() as! String == "") {
                showErrorMessage("Title can't empty")
            }
			else if ((formValues()[Tags.ValidationCountry]! as! XLFormOptionsObject).valueData() as! String == "") {
                showErrorMessage("Country can't empty")
            }
			else if ((formValues()[Tags.ValidationState]! as! XLFormOptionsObject).valueData() as! String == "") {
                showErrorMessage("State can't empty")
            }
			else if minDate.compare(formValues()[Tags.ValidationDate] as! NSDate) == NSComparisonResult.OrderedAscending {
                showErrorMessage("User must age 18 and above to register")
            }
			else if termCheckBox.checkState.rawValue == 0 {
                showErrorMessage("Please check term and condition checkbox")
            }
			else{
                
                let enc = try! EncryptManager.sharedInstance.aesEncrypt(formValues()[Tags.ValidationPassword]! as! String, key: key, iv: iv)
                    var parameters:[String:AnyObject] = [String:AnyObject]()
                    
                    parameters.updateValue(formValues()[Tags.ValidationUsername]!.xmlSimpleEscapeString(), forKey: "username")
                    parameters.updateValue(enc, forKey: "password")
                    parameters.updateValue((formValues()[Tags.ValidationTitle]! as! XLFormOptionsObject).valueData(), forKey: "title")
                    parameters.updateValue(formValues()[Tags.ValidationFirstName]!.xmlSimpleEscapeString(), forKey: "first_name")
                    parameters.updateValue(formValues()[Tags.ValidationLastName]!.xmlSimpleEscapeString(), forKey: "last_name")
                    parameters.updateValue(formatDate(formValues()[Tags.ValidationDate]! as! NSDate), forKey: "dob")
                    parameters.updateValue(formValues()[Tags.ValidationAddressLine1]!.xmlSimpleEscapeString(), forKey: "address_1")
                
                    parameters.updateValue(nullIfEmpty(formValues()[Tags.ValidationAddressLine2])!.xmlSimpleEscapeString(), forKey: "address_2")
                
                    parameters.updateValue("", forKey: "address_3")
                    parameters.updateValue((formValues()[Tags.ValidationCountry]! as! XLFormOptionsObject).valueData(), forKey: "country")
                    parameters.updateValue(formValues()[Tags.ValidationTownCity]!.xmlSimpleEscapeString(), forKey: "city")
                    parameters.updateValue((formValues()[Tags.ValidationState]! as! XLFormOptionsObject).valueData(), forKey: "state")
                    parameters.updateValue(formValues()[Tags.ValidationPostcode]!, forKey: "postcode")
                    parameters.updateValue(formValues()[Tags.ValidationMobileHome]!, forKey: "mobile_phone")

                    parameters.updateValue(nullIfEmpty(formValues()[Tags.ValidationAlternate]!)!, forKey: "alternate_phone")
                
                parameters.updateValue(nullIfEmpty(formValues()[Tags.ValidationEnrichLoyaltyNo])!, forKey: "bonuslink")
                
                if promotionCheckBox.checkState.rawValue == 0 {
                    parameters.updateValue("N", forKey: "newsletter")
                }
                else {
                    parameters.updateValue("Y", forKey: "newsletter")
                }
                
                    parameters.updateValue(nullIfEmpty(formValues()[Tags.ValidationFax])!, forKey: "fax")
                
                    parameters.updateValue("", forKey: "signature")
                    
                    let manager = WSDLNetworkManager()
                    
                    showLoading(self) //showHud("open")
                    manager.sharedClient().createRequestWithService("register", withParams: parameters, completion: { (result) -> Void in
                        //showHud("close")
                        
                        if result["status"].string == "success"{
                            
                            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                            let loginVC = storyBoard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                            self.navigationController!.pushViewController(loginVC, animated: true)
                        }
                        else if result["status"].string == "error_validation"{
                            
                            var str = String()
                            for (_, value) in result["message"].dictionary!{
                                
                                str += "\(value[0])\n"
                            }
                            
                            showErrorMessage(str)
                            
                        }
                        else {
                            showErrorMessage(result["message"].string!)
                        }
                        hideLoading(self)
                    })
                }
        }
    }
}
