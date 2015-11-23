//
//  RegisterPersonalInfoViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

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
        row = XLFormRowDescriptor(tag: Tags.ValidationUsername, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Username"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
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
        
        tempArray.append(XLFormOptionsObject(value: "", displayText: ""))
        
        for title in titleArray{
            tempArray.append(XLFormOptionsObject(value: title["titlecode"], displayText: title["titlename"] as! String))
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
            tempArray.append(XLFormOptionsObject(value: country["countrycode"], displayText: country["countryname"] as! String))
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
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText: "Option 1"),
            XLFormOptionsObject(value: 1, displayText:"Option 2"),
            XLFormOptionsObject(value: 2, displayText:"Option 3"),
            XLFormOptionsObject(value: 3, displayText:"Option 4"),
            XLFormOptionsObject(value: 4, displayText:"Option 5")
        ]
        row.value = XLFormOptionsObject(value: 1, displayText:"Option 2")
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
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeNumber, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Mobile / Home"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Alternate
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeNumber, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Alternate"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        section.addFormRow(row)
        
        // Fax
        row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypeNumber, title:"")
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

    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        let button = sender as! UIButton
        
        validateForm()
        if isValidate {
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
                /*let parameters:[String:AnyObject] = [
                    "username": (form.formRowWithTag(Tags.ValidationUsername)?.value)!,
                    "password": (form.formRowWithTag(Tags.ValidationPassword)?.value)!,
                    "title": (form.formRowWithTag(Tags.ValidationTitle)?.value)!,
                    "first_name": (form.formRowWithTag(Tags.ValidationFirstName)?.value)!,
                    "last_name": (form.formRowWithTag(Tags.ValidationLastName)?.value)!,
                    "dob": (form.formRowWithTag(Tags.ValidationDate)?.value)!,
                    "address_1": (form.formRowWithTag(Tags.ValidationAddressLine1)?.value)!,
                    "address_2": (form.formRowWithTag(Tags.ValidationAddressLine2)?.value)!,
                    "address_3": "",
                    "country": (form.formRowWithTag(Tags.ValidationCountry)?.value)!,
                    "city": (form.formRowWithTag(Tags.ValidationTownCity)?.value)!,
                    "state": (form.formRowWithTag(Tags.ValidationState)?.value)!,
                    "postcode": (form.formRowWithTag(Tags.ValidationPostcode)?.value)!,
                    "mobile_phone": (form.formRowWithTag(Tags.ValidationMobileHome)?.value)!,
                    "alternate_phone": (form.formRowWithTag(Tags.ValidationAlternate)?.value)!,
                    "fax": (form.formRowWithTag(Tags.ValidationFax)?.value)!,
                    "signature" : "",
                ]*/
            }
        }
        
        //validateForm()
        
        /*if isValidate {
            
            
            
            let storyBoard = UIStoryboard(name: "Register", bundle: nil)
            
            let registerAddressVC = storyBoard.instantiateViewControllerWithIdentifier("RegisterAddressVC") as! RegisterAddressViewController
            
            self.navigationController!.pushViewController(registerAddressVC, animated: true)
        }*/
        
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

    func formatDate(date:NSDate) -> String{
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.stringFromDate(date)
        
    }
    //func createSessionedRequestWithService:(NSString*)serviceName withParams:(NSArray*)params  andBeanName:(NSString*)beanName withReturn:(NSString*)returnString withCompletionHandler:(void (^)(id, id, NSError *))handler {
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
