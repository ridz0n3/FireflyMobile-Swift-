//
//  ContactDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/15/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class ContactDetailViewController: BaseXLFormViewController {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var titleArray = NSMutableArray()
    var countryArray = NSMutableArray()
    
    var purposeArray = [["purpose_code":"leisure","purpose_name":"Leisure"],["purpose_code":"business","purpose_name":"Business"]]
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
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
            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
            let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as! PaymentViewController
            self.navigationController!.pushViewController(paymentVC, animated: true)
        }else{
            showToastMessage("Please fill all fields")
        }
        

    }
    
    @IBAction func continueChooseSeatBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
            let chooseSeatVC = storyboard.instantiateViewControllerWithIdentifier("ChooseSeatVC") as! ChooseSeatViewController
            self.navigationController!.pushViewController(chooseSeatVC, animated: true)
        }else{
            showToastMessage("Please fill all fields")
        }

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
