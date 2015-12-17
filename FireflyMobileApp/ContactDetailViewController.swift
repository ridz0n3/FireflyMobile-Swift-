//
//  ContactDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/15/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON
import M13Checkbox

extension String {
    var html2String:NSAttributedString {
        return try! NSAttributedString(data:dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
}

class ContactDetailViewController: BaseXLFormViewController {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var titleArray = NSMutableArray()
    var countryArray = NSMutableArray()
    var stateArray = NSMutableArray()
    
    @IBOutlet weak var chooseSeatBtn: UIButton!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var paragraph1: UITextView!
    @IBOutlet weak var paragraph2: UITextView!
    @IBOutlet weak var paragraph3: UILabel!
    @IBOutlet weak var agreeTerm: M13Checkbox!
    
    var purposeArray = [["purpose_code":"1","purpose_name":"Leisure"],["purpose_code":"2","purpose_name":"Business"]]
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateArray = defaults.objectForKey("state") as! NSMutableArray
        paymentBtn.layer.cornerRadius = 10
        chooseSeatBtn.layer.cornerRadius = 10
        chooseSeatBtn.layer.borderWidth = 1
        chooseSeatBtn.layer.borderColor = UIColor.orangeColor().CGColor
        
        if defaults.objectForKey("insurance_status")?.classForCoder == NSString.classForCoder(){
            views.hidden = true
            var newFrame = footerView.bounds
            newFrame.size.height = 98
            footerView.frame = newFrame
        }else{
            
            var newFrame = footerView.bounds
            newFrame.size.height = 750
            footerView.frame = newFrame
            
            let insuranceData = defaults.objectForKey("insurance_status") as! NSDictionary
            let insuranceArr = insuranceData["html"] as! NSArray
            var index = 0
            var str = ""
            for text in insuranceArr{
                
                if index == 0{
                    
                    let separate = text.componentsSeparatedByString("</html>")
                    
                    str += "\(separate[0])<br>"
                    
                }else if index == 1{
                    let separate = text.componentsSeparatedByString("<html>")
                    
                    str += "\(separate[1])"
                    
                    paragraph1.attributedText = str.html2String
                    
                }else if index == 2{
                    paragraph2.attributedText = (text as! String).html2String
                }else{
                    paragraph3.attributedText = (text as! String).html2String
                }
                
                index++
                
            }
            
        }
        
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        setupLeftButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addBusiness:", name: "addBusiness", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeBusiness:", name: "removeBusiness", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectCountry:", name: "selectCountry", object: nil)
        // Do any additional setup after loading the view.
    }
    
    func addBusiness(sender:NSNotification){
        
        var row : XLFormRowDescriptor
        
        // Company Name
        row = XLFormRowDescriptor(tag: Tags.ValidationCompanyName, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Company Name:*")
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationEmail)
        
        // Address 1
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine1, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Address 1:*")
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationCompanyName)
        
        // Address 2
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine2, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Address 2:*")
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationAddressLine1)
        
        // Address 3
        row = XLFormRowDescriptor(tag: Tags.ValidationAddressLine3, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Address 3:*")
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationAddressLine2)
        
        // City
        row = XLFormRowDescriptor(tag: Tags.ValidationTownCity, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"City:*")
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationCountry)
        
        // State
        row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"State:*")
        row.selectorOptions = [XLFormOptionsObject(value: "", displayText: "")]
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        
        // Postcode
        row = XLFormRowDescriptor(tag: Tags.ValidationPostcode, rowType:XLFormRowDescriptorTypeFloatLabeledTextField, title:"Postcode:*")
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationState)
        
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
        
        if self.formValues()[Tags.ValidationState] != nil{
            var stateArr = [NSDictionary]()
            for stateData in stateArray{
                if stateData["country_code"] as! String == sender.userInfo!["countryVal"]! as! String{
                    stateArr.append(stateData as! NSDictionary)
                }
            }
            
            self.form.removeFormRowWithTag(Tags.ValidationState)
            var row : XLFormRowDescriptor
            row = XLFormRowDescriptor(tag: Tags.ValidationState, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"State:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            if stateArr.count != 0{
                for data in stateArr{
                    tempArray.append(XLFormOptionsObject(value: data["state_code"], displayText: data["state_name"] as! String))
                }
            }else{
                tempArray.append(XLFormOptionsObject(value: 0, displayText: "Other"))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            
            self.form.addFormRow(row, afterRowTag: Tags.ValidationTownCity)
        }
        
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
        let section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        // Purpose
        row = XLFormRowDescriptor(tag: Tags.ValidationPurpose, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Primary Purpose of Your Trip:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for purpose in purposeArray{
            tempArray.append(XLFormOptionsObject(value: purpose["purpose_code"], displayText: purpose["purpose_name"]))
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationTitle, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Title:*")
        
        tempArray = [AnyObject]()
        titleArray = defaults.objectForKey("title") as! NSMutableArray
        for title in titleArray{
            tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        //first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
        row.required = true
        section.addFormRow(row)
        
        //last name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
        row.required = true
        section.addFormRow(row)
        
        //email
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Email Address:*")
        row.required = true
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Country
        row = XLFormRowDescriptor(tag: Tags.ValidationCountry, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Country:*")
        
        tempArray = [AnyObject]()
        countryArray = defaults.objectForKey("country") as! NSMutableArray
        for country in countryArray{
            tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeFloatLabeledPhoneNumber, title:"Mobile Number:*")
        row.required = true
        section.addFormRow(row)
        
        // Alternate Number
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeFloatLabeledPhoneNumber, title:"Alternate Number:*")
        row.required = true
        section.addFormRow(row)
        
        self.form = form
    }
    
    @IBAction func continuePaymentBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            
            let purposeData = getPurpose(formValues()[Tags.ValidationPurpose]! as! String, purposeArr: purposeArray)
            let titleData = getTitleCode(formValues()[Tags.ValidationTitle]! as! String, titleArr: titleArray)
            let firstNameData = formValues()[Tags.ValidationFirstName]!  as! String
            let lastNameData = formValues()[Tags.ValidationLastName]! as! String
            let emailData = formValues()[Tags.ValidationUsername]!  as! String
            let countryData = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
            let mobileData = formValues()[Tags.ValidationMobileHome]!  as! String
            let alternateData = nullIfEmpty(formValues()[Tags.ValidationAlternate])!  as! String
            let signatureData = defaults.objectForKey("signature")!  as! String
            let bookIdData = String(format: "%i", defaults.objectForKey("booking_id")!.integerValue)
            var insuranceData = ""
            if agreeTerm.checkState.rawValue == 0{
                insuranceData = "\(agreeTerm.checkState.rawValue)"
            }else{
                insuranceData = "\(agreeTerm.checkState.rawValue)"
            }
            let companyNameData = nilIfEmpty(formValues()[Tags.ValidationCompanyName])!  as! String
            let address1Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine1])!  as! String
            let address2Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine2])!  as! String
            let address3Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine3])!  as! String
            let cityData = nilIfEmpty(formValues()[Tags.ValidationTownCity])!  as! String
            let stateData = getStateCode(nilIfEmpty(formValues()[Tags.ValidationState])! as! String, stateArr: stateArray) 
            let postcodeData = nilIfEmpty(formValues()[Tags.ValidationPostcode])!  as! String
            
            
            FireFlyProvider.request(.ContactDetail(bookIdData, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signatureData, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData ), completion: { (result) -> () in
                
                switch result {
                case .Success(let successResult):
                    do {
                        self.hideHud()
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if json["status"] == "success"{
                            self.showToastMessage(json["status"].string!)
                            
                            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                            let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as! PaymentViewController
                            self.navigationController!.pushViewController(paymentVC, animated: true)
                        }else{
                            self.showToastMessage(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    print (successResult.data)
                case .Failure(let failureResult):
                    print (failureResult)
                }
                
            })
            
        }else{
            showToastMessage("Please fill all fields")
        }
        
        
    }
    
    @IBAction func continueChooseSeatBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            
            let purposeData = getPurpose(formValues()[Tags.ValidationPurpose]! as! String, purposeArr: purposeArray)
            let titleData = getTitleCode(formValues()[Tags.ValidationTitle]! as! String, titleArr: titleArray)
            let firstNameData = formValues()[Tags.ValidationFirstName]!  as! String
            let lastNameData = formValues()[Tags.ValidationLastName]! as! String
            let emailData = formValues()[Tags.ValidationUsername]!  as! String
            let countryData = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
            let mobileData = formValues()[Tags.ValidationMobileHome]!  as! String
            let alternateData = nullIfEmpty(formValues()[Tags.ValidationAlternate])!  as! String
            let signatureData = defaults.objectForKey("signature")!  as! String
            let bookIdData = String(format: "%i", defaults.objectForKey("booking_id")!.integerValue)
            var insuranceData = ""
            if agreeTerm.checkState.rawValue == 0{
                insuranceData = "\(agreeTerm.checkState.rawValue)"
            }else{
                insuranceData = "\(agreeTerm.checkState.rawValue)"
            }
            let companyNameData = nilIfEmpty(formValues()[Tags.ValidationCompanyName])!  as! String
            let address1Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine1])!  as! String
            let address2Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine2])!  as! String
            let address3Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine3])!  as! String
            let cityData = nilIfEmpty(formValues()[Tags.ValidationTownCity])!  as! String
            let stateData = getStateCode(nilIfEmpty(formValues()[Tags.ValidationState])! as! String, stateArr: stateArray)
            let postcodeData = nilIfEmpty(formValues()[Tags.ValidationPostcode])!  as! String
            
            
            FireFlyProvider.request(.ContactDetail(bookIdData, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signatureData, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData ), completion: { (result) -> () in
                
                switch result {
                case .Success(let successResult):
                    do {
                        self.hideHud()
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if json["status"] == "success"{
                            self.showToastMessage(json["status"].string!)
                            
                            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                            let chooseSeatVC = storyboard.instantiateViewControllerWithIdentifier("ChooseSeatVC") as! ChooseSeatViewController
                            self.navigationController!.pushViewController(chooseSeatVC, animated: true)
                        }else{
                            self.showToastMessage(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    print (successResult.data)
                case .Failure(let failureResult):
                    print (failureResult)
                }
                
            })
            
        }else{
            showToastMessage("Please fill all fields")
        }
    }
    
    func getFormData() -> (String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String){
        
        let purposeData = getPurpose(formValues()[Tags.ValidationPurpose]! as! String, purposeArr: purposeArray)
        let titleData = getTitleCode(formValues()[Tags.ValidationTitle]! as! String, titleArr: titleArray)
        let firstNameData = formValues()[Tags.ValidationFirstName]!  as! String
        let lastNameData = formValues()[Tags.ValidationLastName]! as! String
        let emailData = formValues()[Tags.ValidationUsername]!  as! String
        let countryData = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
        let mobileData = formValues()[Tags.ValidationMobileHome]!  as! String
        let alternateData = nullIfEmpty(formValues()[Tags.ValidationAlternate])!  as! String
        let signatureData = defaults.objectForKey("signature")!  as! String
        let bookIdData = String(format: "%i", defaults.objectForKey("booking_id")!.integerValue)
        var insuranceData = ""
        if agreeTerm.checkState.rawValue == 0{
            insuranceData = "\(agreeTerm.checkState.rawValue)"
        }else{
            insuranceData = "\(agreeTerm.checkState.rawValue)"
        }
        let companyNameData = nilIfEmpty(formValues()[Tags.ValidationCompanyName])!  as! String
        let address1Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine1])!  as! String
        let address2Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine2])!  as! String
        let address3Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine3])!  as! String
        let cityData = nilIfEmpty(formValues()[Tags.ValidationTownCity])!  as! String
        let stateData = getStateCode(nilIfEmpty(formValues()[Tags.ValidationState])! as! String, stateArr: stateArray)
        let postcodeData = nilIfEmpty(formValues()[Tags.ValidationPostcode])!  as! String
        
        return (bookIdData, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signatureData, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData)
        
    }
    
    func getPurpose(purposeName:String, purposeArr:NSArray) -> String{
        
        var purposeCode = String()
        for purposeData in purposeArr{
            if purposeData["purpose_name"] as! String == purposeName{
                purposeCode = purposeData["purpose_code"] as! String
            }
        }
        return purposeCode
        
    }
    
    override func validateForm() {
        let array = formValidationErrors()
        
        if array.count != 0{
            isValidate = false
            
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                if validationStatus.rowDescriptor!.tag == Tags.ValidationTitle ||
                    validationStatus.rowDescriptor!.tag == Tags.ValidationCountry || validationStatus.rowDescriptor!.tag == Tags.ValidationPurpose{
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledPickerCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                        
                        
                }else if validationStatus.rowDescriptor!.tag == Tags.ValidationMobileHome || validationStatus.rowDescriptor!.tag == Tags.ValidationAlternate{
                    let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                    
                    if self.tableView.cellForRowAtIndexPath(index) != nil{
                        let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledPhoneCell
                        
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
        }else{
            isValidate = true
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
