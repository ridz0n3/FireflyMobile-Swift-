//
//  CommonPassengerDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON

class CommonPassengerDetailViewController: BaseXLFormViewController {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    var titleArray = NSMutableArray()
    var countryArray = NSMutableArray()
    var adultCount = Int()
    var infantCount = Int()
    var adultArray = NSMutableArray()
    
    var adultData = NSMutableArray()
    var infantData = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        setupLeftButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addExpiredDate:", name: "expiredDate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeExpiredDate:", name: "removeExpiredDate", object: nil)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("PassengerHeader", owner: self, options: nil)[0] as! PassengerHeaderView
        
        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        
        return sectionView
        
    }

    func getFormData()->([String:AnyObject], [String:AnyObject], String, String){
        var passenger = [String:AnyObject]()
        for var i = 0; i < adultCount; i = i + 1{
            var count = i
            count = count + 1
            var adultInfo = [String:AnyObject]()
            
            adultInfo.updateValue(getTitleCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationTitle, count)] as! String, titleArr: titleArray), forKey: "title")
            adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationFirstName, count)]!, forKey: "first_name")
            adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationLastName, count)]!, forKey: "last_name")
            adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationDate, count)]!, forKey: "dob")
            adultInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationTravelDoc, count)] as! String, docArr: travelDoc), forKey: "travel_document")
            adultInfo.updateValue(getCountryCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationCountry, count)] as! String, countryArr: countryArray), forKey: "issuing_country")
            adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationDocumentNo, count)]!, forKey: "document_number")
            adultInfo.updateValue(nilIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationExpiredDate, count)])!, forKey: "expiration_date")
            adultInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, count)])!, forKey: "enrich_loyalty_number")
            
            passenger.updateValue(adultInfo, forKey: "\(i)")
            
        }
        
        var infant = [String:AnyObject]()
        for var j = 0; j < infantCount; j = j + 1{
            var count = j
            count = count + 1
            var infantInfo = [String:AnyObject]()
            
            infantInfo.updateValue(getTravelWithCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelWith, count)] as! String, travelArr: adultArray), forKey: "traveling_with")
            infantInfo.updateValue(getGenderCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationGender, count)] as! String, genderArr: genderArray), forKey: "gender")
            infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationFirstName, count)]!, forKey: "first_name")
            infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationLastName, count)]!, forKey: "last_name")
            infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]!, forKey: "dob")
            infantInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelDoc, count)] as! String, docArr: travelDoc), forKey: "travel_document")
            infantInfo.updateValue(getCountryCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationCountry, count)] as! String, countryArr: countryArray), forKey: "issuing_country")
            infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationDocumentNo, count)]!, forKey: "document_number")
            infantInfo.updateValue(nilIfEmpty(formValues()[String(format: "%@(infant%i)", Tags.ValidationExpiredDate, count)])!, forKey: "expiration_date")
            
            infant.updateValue(infantInfo, forKey: "\(j)")
        }
        
        let bookId = String(format: "%i", defaults.objectForKey("booking_id")!.integerValue)
        let signature = defaults.objectForKey("signature") as! String
        
        
        return (passenger, infant, bookId, signature)
    }

    override func validateForm() {
        let array = formValidationErrors()
        
        if array.count != 0{
            isValidate = false
            
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let errorTag = validationStatus.rowDescriptor!.tag!.componentsSeparatedByString("(")
                
                if errorTag[0] == Tags.ValidationTitle ||
                    errorTag[0] == Tags.ValidationCountry || errorTag[0] == Tags.ValidationTravelDoc || errorTag[0] == Tags.ValidationTravelWith || errorTag[0] == Tags.ValidationGender{
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledPickerCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                        
                        
                }else if errorTag[0] == Tags.ValidationDate || errorTag[0] == Tags.ValidationExpiredDate{
                    let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                    
                    if self.tableView.cellForRowAtIndexPath(index) != nil{
                        let cell = self.tableView.cellForRowAtIndexPath(index) as! FloateLabeledDatePickerCell
                        
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
                //showToastMessage("Please fill all fields")
                
            }
        }else{
            isValidate = true
        }
    }
    
    func addExpiredDate(sender:NSNotification){
        
        let newTag = sender.userInfo!["tag"]!.componentsSeparatedByString("(")
        
        var row : XLFormRowDescriptor
        
        // Date
        row = XLFormRowDescriptor(tag: String(format: "%@(%@", Tags.ValidationExpiredDate,newTag[1]), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Expiration Date:*")
        row.required = true
        self.form.addFormRow(row, afterRowTag: String(format: "%@(%@",Tags.ValidationDocumentNo, newTag[1]))
        
    }
    
    func removeExpiredDate(sender:NSNotification){
        
        let newTag = sender.userInfo!["tag"]!.componentsSeparatedByString("(")
        self.form.removeFormRowWithTag(String(format: "%@(%@",Tags.ValidationExpiredDate, newTag[1]))
        
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
