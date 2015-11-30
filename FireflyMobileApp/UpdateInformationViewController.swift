//
//  UpdateInformationViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/29/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class UpdateInformationViewController: BaseXLFormViewController {
    
    var userInfo = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        var stateArr = [NSDictionary]()
        let defaults = NSUserDefaults.standardUserDefaults()
        let state = defaults.objectForKey("state") as! NSMutableArray
        
        for stateData in state{
            if stateData["country_code"] as! String == userInfo["contact_country"] as! String{
                stateArr.append(stateData as! NSDictionary)
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
        
        row.selectorOptions = tempArray
        row.cellConfigAtConfigure.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellStyle = .Value2
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.required = true
        
        self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    func initializeForm() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        userInfo = defaults.objectForKey("userInfo") as! NSMutableDictionary
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSectionWithTitle("Login Information")
        //section.hidden = "$\(Tags.Button1).value contains 'hide'"
        form.addFormSection(section)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Email"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.value = userInfo["username"]
        row.required = true
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.addValidator(XLFormRegexValidator(msg: "The password must contain \n (number, symbol, uppercase, lowercase)", andRegexString: "^(?=.*[a-zA-Z0-9])[a-zA-Z0-9][^,.~]{8,16}$"))
        row.required = true
        section.addFormRow(row)
        
        // Confirm Password
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Confirm Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        section.title = "Personal Information"
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*Title")
        
        var tempArray:[AnyObject] = [AnyObject]()
        let titleArray = defaults.objectForKey("title") as! NSMutableArray
        
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
        row.cellConfigAtConfigure["textField.placeholder"] = "*First Name"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = userInfo["contact_first_name"]
        section.addFormRow(row)
        
        // Last Name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Last Name"
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
        row.cellConfigAtConfigure["textField.placeholder"] = "*Address Line 1"
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
        let countryArray = defaults.objectForKey("country") as! NSMutableArray
        
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
        row.cellConfigAtConfigure["textField.placeholder"] = "*Town / City"
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
        row.cellConfigAtConfigure["textField.placeholder"] = "*Postcode"
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
        row.cellConfigAtConfigure["textField.placeholder"] = "*Mobile / Home"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = userInfo["contact_mobile_phone"]
        section.addFormRow(row)
        
        // Alternate
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Alternate"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.value = userInfo["contact_alternate_phone"]
        section.addFormRow(row)
        
        // Fax
        row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Fax"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.value = userInfo["contact_fax"]
        section.addFormRow(row)
        
        self.form = form
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
            let defaults = NSUserDefaults.standardUserDefaults()
            let state = defaults.objectForKey("state") as! NSMutableArray
            
            for stateData in state{
                if stateData["country_code"] as! String == (form.formRowWithTag(Tags.ValidationCountry)?.value as! XLFormOptionObject).formValue() as! String{
                    stateArr.append(stateData as! NSDictionary)
                }
            }
            
            self.form.removeFormRowWithTag(Tags.ValidationState)
            var row : XLFormRowDescriptor
            row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*State")
            
            var tempArray:[AnyObject] = [AnyObject]()
            
            for data in stateArr{
                tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
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
            
            if (form.formRowWithTag(Tags.ValidationPassword)?.value)! as! String != (form.formRowWithTag(Tags.ValidationConfirmPassword)?.value)! as! String{
                
                //let index = form.indexPathOfFormRow(form.formRowWithTag(Tags.ValidationConfirmPassword)!)! as NSIndexPath
                //let cell = self.tableView.cellForRowAtIndexPath(index) as! XLFormTextFieldCell
                
                /*let cell = self.tableView.cellForRowAtIndexPath(self.form .indexPathOfFormRow(self.form.formRowWithTag(Tags.ValidationConfirmPassword)!)!) as! XLFormTextFieldCell
                
                
                
                cell.backgroundColor = .orangeColor()
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                cell.backgroundColor = UIColor(patternImage: UIImage(named: "txtField")!)
                })
                
                animateCell(cell)*/
                showToastMessage("Confirm password is incorrect")
            }else {
                var parameters:[String:AnyObject] = [String:AnyObject]()
                
                parameters.updateValue(formValues()[Tags.ValidationUsername]!, forKey: "username")
                parameters.updateValue(formValues()[Tags.ValidationPassword]!, forKey: "password")
                
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
                
                parameters.updateValue("", forKey: "signature")
                
                /*
                let manager = WSDLNetworkManager()
                
                showHud()
                manager.sharedClient().createRequestWithService("Register", withParams: parameters, completion: { (result) -> Void in
                    self.hideHud()
                    
                    if result["status"] as! String == "success"{
                        self.showToastMessage(result["status"] as! String)
                        
                        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                        let loginVC = storyBoard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                        self.navigationController!.pushViewController(loginVC, animated: true)
                    }else{
                        self.showToastMessage(result["status"] as! String)
                    }
                    
                })*/
            }
        }else{
            self.showToastMessage("Please Fill All Field")
        }
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
