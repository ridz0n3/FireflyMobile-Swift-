//
//  RegisterPersonalInfoViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class RegisterPersonalInfoViewController: BaseXLFormViewController {

    @IBOutlet weak var lvlHeaderImg: UIImageView!
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    
    var test = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lvlHeaderImg.image = UIImage(named: "registerLvl1")
        setupLeftButton()
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
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        
        form = XLFormDescriptor(title: "")
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSectionWithTitle("Basic Information")
        section.hidden = "$\(Tags.Button1).value contains 'hide'"
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Button1, rowType: XLFormRowDescriptorTypeText, title:"")
        row.hidden = true
        section.addFormRow(row)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Email"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
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
        section.hidden = "$\(Tags.Button1).value contains 'hide'"
        form.addFormSection(section)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*Title")
        
        var tempArray:[AnyObject] = [AnyObject]()
        var defaults = NSUserDefaults.standardUserDefaults()
        let titleArray = defaults.objectForKey("title") as! NSMutableArray
        
        for title in titleArray{
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.value = tempArray[0]
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.required = true
        section.addFormRow(row)
        
        // First Name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*First Name"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Last Name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Last Name"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
    
        // Date
        row = XLFormRowDescriptor(tag: Tags.ValidationDate, rowType:XLFormRowDescriptorTypeDate, title:"*Date of Birth")
        row.value = NSDate()
        
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "dot_date")!)
        row.required = true
        section.addFormRow(row)
        
        // Basic Information - Section
        section = XLFormSectionDescriptor()
        section.title = "Address Information"
        section.hidden = "$\(Tags.Button2).value contains 'hide'"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Button2, rowType: XLFormRowDescriptorTypeText, title:"")
        row.hidden = true
        row.value = "hide"
        section.addFormRow(row)
        
        // Address Line 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Address Line 1"
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
        
        tempArray = [AnyObject]()
        defaults = NSUserDefaults.standardUserDefaults()
        let countryArray = defaults.objectForKey("country") as! NSMutableArray
        
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
        row.cellConfigAtConfigure["textField.placeholder"] = "*Town / City"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:"*State")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.value = XLFormOptionsObject(value: "", displayText:"")
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.required = true
        section.addFormRow(row)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType: XLFormRowDescriptorTypeNumber, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Postcode"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Contact Information - Section
        section = XLFormSectionDescriptor()
        section.title = "Contact Information"
        section.hidden = "$\(Tags.Button3).value contains 'hide'"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Button3, rowType: XLFormRowDescriptorTypeText, title:"")
        row.hidden = true
        row.value = "hide"
        section.addFormRow(row)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Mobile / Home"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Alternate
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Alternate"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        section.addFormRow(row)
        
        // Fax
        row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypePhone, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Fax"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = NSBundle.mainBundle().loadNibNamed("SectionView", owner: self, options: nil)[0] as! SectionView
        
        sectionView.frame = CGRectMake(0, 0,self.view.frame.size.width, 50)
        sectionView.backgroundColor = UIColor(patternImage: UIImage(named: "lines")!)
        
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title
        
        return sectionView
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
            
            row.selectorOptions = tempArray
            row.value = tempArray[0]
            row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
            row.required = true
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        }
    }

    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        let button = sender as! UIButton
        
        validateForm()
        
        if isValidate {
            
            if (form.formRowWithTag(Tags.ValidationPassword)?.value)! as! String != (form.formRowWithTag(Tags.ValidationConfirmPassword)?.value)! as! String{
                
                let index = form.indexPathOfFormRow(form.formRowWithTag(Tags.ValidationConfirmPassword)!)! as NSIndexPath
                let cell = self.tableView.cellForRowAtIndexPath(index) as! XLFormTextFieldCell
                
                cell.backgroundColor = .orangeColor()
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    cell.backgroundColor = UIColor(patternImage: UIImage(named: "txtField")!)
                })
                
                animateCell(cell)
                showToastMessage("Confirm password is incorrect")
            }else {
                if button.tag == 1{
                    self.lvlHeaderImg.image = UIImage(named: "registerLvl2")
                    form.formRowWithTag(Tags.Button1)?.value = "hide"
                    form.formRowWithTag(Tags.Button2)?.value = "notHide"
                    form.formRowWithTag(Tags.Button3)?.value = "hide"
                    self.continueBtn.tag = 2
                }else if button.tag == 2{
                    self.lvlHeaderImg.image = UIImage(named: "registerLvl3")
                    form.formRowWithTag(Tags.Button1)?.value = "hide"
                    form.formRowWithTag(Tags.Button2)?.value = "hide"
                    form.formRowWithTag(Tags.Button3)?.value = "notHide"
                    self.continueBtn.tag = 3
                }else{
                    
                    var parameters:[String:AnyObject] = [String:AnyObject]()
                    
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationUsername)?.value)!, forKey: "username")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationPassword)?.value)!, forKey: "password")
                    
                    parameters.updateValue(((form.formRowWithTag(Tags.ValidationTitle)?.value)! as! XLFormOptionsObject).valueData(), forKey: "title")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationFirstName)?.value)!, forKey: "first_name")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationLastName)?.value)!, forKey: "last_name")
                    parameters.updateValue(formatDate((form.formRowWithTag(Tags.ValidationDate)?.value)! as! NSDate), forKey: "dob")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationAddressLine1)?.value)!, forKey: "address_1")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationAddressLine2)?.value)!, forKey: "address_2")
                    parameters.updateValue("", forKey: "address_3")
                    parameters.updateValue(((form.formRowWithTag(Tags.ValidationCountry)?.value)! as! XLFormOptionsObject).valueData(), forKey: "country")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationTownCity)?.value)!, forKey: "city")
                    parameters.updateValue(((form.formRowWithTag(Tags.ValidationState)?.value)! as! XLFormOptionsObject).valueData(), forKey: "state")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationPostcode)?.value)!, forKey: "postcode")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationMobileHome)?.value)!, forKey: "mobile_phone")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationAlternate)?.value)!, forKey: "alternate_phone")
                    parameters.updateValue((form.formRowWithTag(Tags.ValidationFax)?.value)!, forKey: "fax")
                    parameters.updateValue("", forKey: "signature")
                    
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
                        
                    })
                }
            }
        }
        
    }
    
    override func backButtonPressed(sender: UIBarButtonItem) {
        
        if self.continueBtn.tag == 3{
            self.lvlHeaderImg.image = UIImage(named: "registerLvl2")
            form.formRowWithTag(Tags.Button1)?.value = "hide"
            form.formRowWithTag(Tags.Button2)?.value = "notHide"
            form.formRowWithTag(Tags.Button3)?.value = "hide"
            self.continueBtn.tag = 2
            tableView.reloadData()
        }else if self.continueBtn.tag == 2{
            self.lvlHeaderImg.image = UIImage(named: "registerLvl1")
            form.formRowWithTag(Tags.Button1)?.value = "notHide"
            form.formRowWithTag(Tags.Button2)?.value = "hide"
            form.formRowWithTag(Tags.Button3)?.value = "hide"
            self.continueBtn.tag = 1
            tableView.reloadData()
        }else if self.continueBtn.tag == 1{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }

}
