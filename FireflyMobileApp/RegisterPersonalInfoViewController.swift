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
    @IBOutlet weak var continueBtn: UIButton!
    
    var fromLogin = Bool()
    var dialCode = String()
    var stateArray = [Dictionary<String,AnyObject>]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if fromLogin{
            setupLeftButton()
        }else{
            setupMenuButton()
        }
        
        continueBtn.layer.cornerRadius = 10
        termCheckBox.strokeColor = UIColor.orange
        termCheckBox.checkColor = UIColor.orange
        promotionCheckBox.strokeColor = UIColor.orange
        promotionCheckBox.checkColor = UIColor.orange
        
        stateArray = defaults.object(forKey: "state") as! [Dictionary<String, AnyObject>]
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterPersonalInfoViewController.selectCountry(_:)), name: NSNotification.Name(rawValue: "selectCountry"), object: nil)
        
        initializeForm()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.registerScreen)
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
        section = XLFormSectionDescriptor.formSection(withTitle: "LabelBasic".localized)
        //section.hidden = "$\(Tags.Button1).value contains 'hide'"
        form.addFormSection(section)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Email:*")
        row.isRequired = true
        row.addValidator(XLFormValidator.email())
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Password:*")
        row.isRequired = true
        section.addFormRow(row)
        
        // Confirm Password
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmPassword, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Confirm Password:*")
        row.isRequired = true
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "LabelPersonal".localized
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Title:*")
        var tempArray:[AnyObject] = [AnyObject]()
        for title in titleArray{
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.isRequired = true
        section.addFormRow(row)
        
        // First Name/Given Name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        row.isRequired = true
        section.addFormRow(row)
        
        // Last Name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Last Name/Family Name:*")
        row.isRequired = true
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Date of Birth:*")
        row.isRequired = true
        section.addFormRow(row)
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelAddress".localized
        form.addFormSection(section)
        
        // Address Line 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Address Line 1:*")
        row.isRequired = true
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
        row.isRequired = true
        section.addFormRow(row)
        
        // Town/City
        row = XLFormRowDescriptor(tag: Tags.ValidationTownCity, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Town / City:*")
        row.isRequired = true
        section.addFormRow(row)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeled, title:"State:*")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.isRequired = true
        section.addFormRow(row)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Postcode:*")
        row.isRequired = true
        section.addFormRow(row)
        
        // Contact Information - Section
        section = XLFormSectionDescriptor()
        section.title = "LabelContact".localized
        form.addFormSection(section)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Mobile / Home:")
        row.addValidator(XLFormRegexValidator(msg: "Mobile phone must start with country code and not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
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
        form.addFormSection(section)
        
        // BonusLink
        row = XLFormRowDescriptor(tag: Tags.ValidationEnrichLoyaltyNo, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No :")
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = Bundle.main.loadNibNamed("SectionView", owner: self, options: nil)?[0] as! SectionView
        
        sectionView.changePassLbl.isHidden = true
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSection(at: index)?.title
        
        return sectionView
        
    }
    
    func selectCountry(_ sender:NSNotification){
        
        country(sender.userInfo!["countryVal"]! as! String)
        
        dialCode = sender.userInfo!["dialingCode"]! as! String
        
        var row : XLFormRowDescriptor
        
        self.form.removeFormRow(withTag: Tags.ValidationMobileHome)
        
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
    
    @IBAction func continueButtonPressed(_ sender: AnyObject) {
        
        validateForm()
        
        if isValidate {
            
            let currentDate: Date = Date()
            let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            calendar.timeZone = TimeZone(identifier: "UTC")! //TimeZone(name: "UTC")!
            
            var components: DateComponents = DateComponents()
            components.calendar = calendar as Calendar
            
            components.year = -18
            let minDate: Date = calendar.date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
            
            let date = formValues()[Tags.ValidationDate]! as! String
            let selectDate: Date = stringToDate(date) as Date
            
            if formValues()[Tags.ValidationPassword]! as! String != formValues()[Tags.ValidationConfirmPassword]! as! String {
                showErrorMessage("Confirm password incorrect")
            }
            else if minDate.compare(selectDate) == ComparisonResult.orderedAscending {
                showErrorMessage("User must age 18 and above to register")
            }
            else if termCheckBox.checkState.rawValue == 0 {
                showErrorMessage("Please check term and condition checkbox")
            }
            else{
                
                let enc = try! EncryptManager.sharedInstance.aesEncrypt(formValues()[Tags.ValidationPassword]! as! String, key: key, iv: iv)
                
                let username = (formValues()[Tags.ValidationUsername]! as! String).xmlSimpleEscape
                let password = enc
                let title = getTitleCode(formValues()[Tags.ValidationTitle] as! String, titleArr: titleArray)
                let firstName = formValues()[Tags.ValidationFirstName]! as! String
                let lastName = formValues()[Tags.ValidationLastName]! as! String
                let dob = formatDate(selectDate)
                let address1 = (formValues()[Tags.ValidationAddressLine1]! as! String).xmlSimpleEscape
                let address2 = nullIfEmpty(formValues()[Tags.ValidationAddressLine2] as AnyObject).xmlSimpleEscape
                let address3 = nullIfEmpty(formValues()[Tags.ValidationAddressLine3] as AnyObject).xmlSimpleEscape
                let country = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
                let city = (formValues()[Tags.ValidationTownCity]! as! String).xmlSimpleEscape
                let state = getStateCode(formValues()[Tags.ValidationState]! as! String, stateArr: stateArray)
                let postcode = formValues()[Tags.ValidationPostcode]! as! String
                let mobilePhone = nullIfEmpty(formValues()[Tags.ValidationMobileHome] as AnyObject)
                let alternatePhone = nullIfEmpty(formValues()[Tags.ValidationAlternate] as AnyObject)
                let fax = nullIfEmpty(formValues()[Tags.ValidationFax] as AnyObject)
                let bonuslink = nullIfEmpty(formValues()[Tags.ValidationEnrichLoyaltyNo] as AnyObject)
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
                    case .success(let successResult):
                        do {
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                
                                let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                                let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
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
                        
                    case .failure(let failureResult):
                        
                        hideLoading()
                        showErrorMessage(failureResult.localizedDescription)
                    }
                    
                    
                })
            }
        }
    }
}
