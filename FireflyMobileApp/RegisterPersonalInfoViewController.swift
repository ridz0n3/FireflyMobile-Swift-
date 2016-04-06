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
import SwiftyJSON

class RegisterPersonalInfoViewController: BaseXLFormViewController {
    
    @IBOutlet weak var termCheckBox: M13Checkbox!
    @IBOutlet weak var promotionCheckBox: M13Checkbox!
    var fromLogin = Bool()
    var dialCode = String()
    var stateArray = [Dictionary<String,AnyObject>]()
    @IBOutlet weak var continueBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        if fromLogin{
            setupLeftButton()
        }else{
            setupMenuButton()
        }
        
        stateArray = defaults.objectForKey("state") as! [Dictionary<String, AnyObject>]
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectCountry:", name: "selectCountry", object: nil)
        
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
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSectionWithTitle("LabelBasic".localized)
        //section.hidden = "$\(Tags.Button1).value contains 'hide'"
        form.addFormSection(section)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Email:*")
        row.required = true
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Password:*")
        //row.addValidator(XLFormRegexValidator(msg: "Password must be at least 8 characters, no more than 16 characters, must include at least one upper case letter, one lower case letter, one numeric digit, and one non-alphanumeric. The password cannot contain a period(.) comma(,) or tilde(~).", andRegexString: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=-])(?=\\S+$).{8,16}$"))
        row.required = true
        section.addFormRow(row)
        //^(?=.*[a-zA-Z0-9])[a-zA-Z0-9][^,.~]{8,16}$
        
        // Confirm Password
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmPassword, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Confirm Password:*")
        row.required = true
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "LabelPersonal".localized
        //section.hidden = "$\(Tags.Button1).value contains 'hide'"
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
        var tempArray:[AnyObject] = [AnyObject]()
        for title in titleArray{
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // First Name/Given Name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.required = true
        section.addFormRow(row)
        
        // Last Name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        row.required = true
        //row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
        row.required = true
        section.addFormRow(row)
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelAddress".localized
        //section.hidden = "$\(Tags.Button2).value contains 'hide'"
        form.addFormSection(section)
        
        // Address Line 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 1:*")
        row.required = true
        section.addFormRow(row)
        
        // Address Line 2
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine2, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 2:")
        section.addFormRow(row)
        
        // Address Line 3
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine3, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 3:")
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Country:*")
        
        tempArray = [AnyObject]()
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Town/City
        row = XLFormRowDescriptor(tag: Tags.ValidationTownCity, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Town / City:*")
        row.required = true
        section.addFormRow(row)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"State:*")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.required = true
        section.addFormRow(row)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Postcode:*")
        row.required = true
        section.addFormRow(row)
        
        // Contact Information - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelContact".localized
        //section.hidden = "$\(Tags.Button3).value contains 'hide'"
        form.addFormSection(section)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile / Home:")
        row.addValidator(XLFormRegexValidator(msg: "Mobile phone must start with country code and not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
        //row.required = true
        section.addFormRow(row)
        
        // Alternate
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Alternate Phone:")
        row.addValidator(XLFormRegexValidator(msg: "Alternate phone must start with country code and not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
        section.addFormRow(row)
        
        // Fax
        row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Fax:")
        section.addFormRow(row)
        
        // BonusLink - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelLoyalty".localized
        //section.hidden = "$\(Tags.Button3).value contains 'hide'"
        form.addFormSection(section)
        
        // BonusLink
        row = XLFormRowDescriptor(tag: Tags.ValidationEnrichLoyaltyNo, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No :")
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = NSBundle.mainBundle().loadNibNamed("SectionView", owner: self, options: nil)[0] as! SectionView
        
        sectionView.changePassLbl.hidden = true
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title
        
        return sectionView
    }
    
    func selectCountry(sender:NSNotification){
        country(sender.userInfo!["countryVal"]! as! String)
        
        dialCode = sender.userInfo!["dialingCode"]! as! String
        
        var row : XLFormRowDescriptor
        
        self.form.removeFormRowWithTag(Tags.ValidationMobileHome)
        
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
            
            let date = formValues()[Tags.ValidationDate]! as! String
            let arrangeDate = date.componentsSeparatedByString("-")
            
            let selectDate: NSDate = stringToDate("\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])")
            
            if formValues()[Tags.ValidationPassword]! as! String != formValues()[Tags.ValidationConfirmPassword]! as! String {
                showErrorMessage("Confirm password incorrect")
            }
            else if minDate.compare(selectDate) == NSComparisonResult.OrderedAscending {
                showErrorMessage("User must age 18 and above to register")
            }
            else if termCheckBox.checkState.rawValue == 0 {
                showErrorMessage("Please check term and condition checkbox")
            }
            else{
                
                let enc = try! EncryptManager.sharedInstance.aesEncrypt(formValues()[Tags.ValidationPassword]! as! String, key: key, iv: iv)
                
                let username = formValues()[Tags.ValidationUsername]!.xmlSimpleEscapeString()
                let password = enc
                let title = getTitleCode(formValues()[Tags.ValidationTitle] as! String, titleArr: titleArray) //formValues()[Tags.ValidationTitle]! as! XLFormOptionsObject).valueData() as! String
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
                let signature = ""
                var newsletter = ""
                
                if promotionCheckBox.checkState.rawValue == 0 {
                    newsletter = "N"
                }
                else {
                    newsletter = "Y"
                }
                
                showLoading()
                FireFlyProvider.request(.RegisterUser(username, password, title, firstName, lastName, dob, address1, address2, address3, country, city, state, postcode, mobilePhone, alternatePhone, fax, bonuslink, signature, newsletter), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                                let loginVC = storyBoard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                                self.navigationController!.pushViewController(loginVC, animated: true)
                                
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
        }
    }
}
