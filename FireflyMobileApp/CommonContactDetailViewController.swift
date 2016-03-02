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
    var contactData = Dictionary<String,AnyObject>()
    
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var paragraph1: UITextView!
    @IBOutlet weak var paragraph2: UITextView!
    @IBOutlet weak var paragraph3: UILabel!
    @IBOutlet weak var agreeTerm: M13Checkbox!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    var titleArray = defaults.objectForKey("title") as! [Dictionary<String,AnyObject>]
    var countryArray = defaults.objectForKey("country") as! [Dictionary<String,AnyObject>]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        stateArray = defaults.objectForKey("state") as! [Dictionary<String,AnyObject>]
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addBusiness:", name: "addBusiness", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeBusiness:", name: "removeBusiness", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectCountry:", name: "selectCountry", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        let section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        // Purpose
        row = XLFormRowDescriptor(tag: Tags.ValidationPurpose, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Primary Purpose of Your Trip:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for purpose in purposeArray{
            tempArray.append(XLFormOptionsObject(value: purpose["purpose_code"], displayText: purpose["purpose_name"] as! String))
            
            if contactData["travel_purpose"] as? String == purpose["purpose_code"] as! String{
                row.value = purpose["purpose_name"]
            }
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Title:*")
        
        tempArray = [AnyObject]()
        for title in titleArray {
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as? String))
            
            if contactData["title"] as? String == title["title_code"] as? String{
                row.value = title["title_name"]
            }
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        //first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
        row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.required = true
        row.value = contactData["first_name"]
        section.addFormRow(row)
        
        //last name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
        row.addValidator(XLFormRegexValidator(msg: "Last name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.required = true
        row.value = contactData["last_name"]
        section.addFormRow(row)
        
        //email
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Email Address:*")
        row.required = true
        row.value = contactData["email"]
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Country:*")
        
        tempArray = [AnyObject]()
        
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            
            if contactData["country"] as? String == country["country_code"]  as? String{
                row.value = country["country_name"]
            }
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Mobile Number:*")
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "Mobile phone must not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
        row.value = contactData["mobile_phone"]
        section.addFormRow(row)
        
        // Alternate Number
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Alternate Number:*")
        row.addValidator(XLFormRegexValidator(msg: "Alternate phone must not less than 7 digits.", andRegexString: "^[0-9]{7,}$"))
        row.required = true
        row.value = contactData["alternate_phone"]
        section.addFormRow(row)
        
        self.form = form
        
        if contactData["travel_purpose"] as? String == "2"{
            addBusinessRow()
        }
    }
    
    override func validateForm() {
        let array = formValidationErrors()
        
        if array.count != 0{
            isValidate = false
            var i = 0
            var message = String()
            
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let empty = validationStatus.msg.componentsSeparatedByString("*")
                
                if empty.count == 1{
                    
                    message += "\(validationStatus.msg),\n"
                    i++
                    
                }else{
                    if validationStatus.rowDescriptor!.tag == Tags.ValidationTitle ||
                        validationStatus.rowDescriptor!.tag == Tags.ValidationCountry || validationStatus.rowDescriptor!.tag == Tags.ValidationPurpose{
                            let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                            
                            if self.tableView.cellForRowAtIndexPath(index) != nil{
                                let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledPickerCell
                                
                                let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                                cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                                
                                animateCell(cell)
                            }
                            
                            
                    }else{
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledTextFieldCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                    }
                }
            }
            if i != 0{
                showErrorMessage(message)
            }
        }else{
            isValidate = true
        }
    }
    
    func getPurpose(purposeName:String, purposeArr:[Dictionary<String,AnyObject>]) -> String{
        
        var purposeCode = String()
        for purposeData in purposeArr{
            if purposeData["purpose_name"] as! String == purposeName{
                purposeCode = purposeData["purpose_code"] as! String
            }
        }
        return purposeCode
    }
    
    func addBusiness(sender:NSNotification){
        addBusinessRow()
    }
    
    func addBusinessRow(){
        var row : XLFormRowDescriptor
        
        // Company Name
        row = XLFormRowDescriptor(tag: Tags.ValidationCompanyName, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Company Name:*")
        row.required = true
        row.value = contactData["company_name"]
        self.form.addFormRow(row, afterRowTag: Tags.ValidationEmail)
        
        // Address 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Address 1:*")
        row.required = true
        row.value = contactData["address1"]
        self.form.addFormRow(row, afterRowTag: Tags.ValidationCompanyName)
        
        // Address 2
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine2, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Address 2:*")
        row.required = true
        row.value = contactData["address2"]
        self.form.addFormRow(row, afterRowTag: Tags.ValidationAddressLine1)
        
        // Address 3
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine3, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Address 3:*")
        row.required = true
        row.value = contactData["address3"]
        self.form.addFormRow(row, afterRowTag: Tags.ValidationAddressLine2)
        
        // City
        row = XLFormRowDescriptor(tag: Tags.ValidationTownCity, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"City:*")
        row.required = true
        row.value = contactData["city"]
        self.form.addFormRow(row, afterRowTag: Tags.ValidationCountry)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"State:*")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.value = contactData["state"]
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Postcode:*")
        row.required = true
        row.value = contactData["postcode"]
        self.form.addFormRow(row, afterRowTag: Tags.ValidationState)
        
        if nullIfEmpty(self.formValues()["Country"]!) as! String != ""{
            country(getCountryCode(self.formValues()["Country"]! as! String, countryArr: countryArray))
        }
    }
    
    func removeBusiness(sender:NSNotification){
        
        self.form.removeFormRowWithTag(Tags.ValidationCompanyName)
        self.form.removeFormRowWithTag(Tags.ValidationAddressLine1)
        self.form.removeFormRowWithTag(Tags.ValidationAddressLine2)
        self.form.removeFormRowWithTag(Tags.ValidationAddressLine3)
        self.form.removeFormRowWithTag(Tags.ValidationTownCity)
        self.form.removeFormRowWithTag(Tags.ValidationState)
        self.form.removeFormRowWithTag(Tags.ValidationPostcode)
        
    }
    
    func selectCountry(sender:NSNotification){
        country(sender.userInfo!["countryVal"]! as! String)
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
            row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"State:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            if stateArr.count != 0{
                for data in stateArr{
                    tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
                    
                    
                    if nilIfEmpty(contactData["state"]) as! String == data["state_code"] as! String{
                        row.value = data["state_name"]
                    }
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
    
}
