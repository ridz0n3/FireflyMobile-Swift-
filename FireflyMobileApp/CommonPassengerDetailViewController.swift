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
    
    var adultCount = Int()
    var infantCount = Int()
    var adultArray = [Dictionary<String,AnyObject>]()
    
    var adultDetails = [Dictionary<String,AnyObject>]()
    var infantDetails = [Dictionary<String,AnyObject>]()
    
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
            adultInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, count)])!, forKey: "bonuslink")
            
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
        defaults.setObject(infant, forKey: "infant")
        defaults.synchronize()
        
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
                //showErrorMessage("Please fill all fields")
                
            }
        }else{
            isValidate = true
        }
    }
    
    func addExpiredDate(sender:NSNotification){
        let newTag = sender.userInfo!["tag"]!.componentsSeparatedByString("(")
        
        addExpiredDateRow(newTag[1], date: "")
        
    }
    
    func addExpiredDateRow(tag : String, date: String){
        
        var row : XLFormRowDescriptor
        
        // Date
        row = XLFormRowDescriptor(tag: String(format: "%@(%@", Tags.ValidationExpiredDate,tag), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Expiration Date:*")
        row.required = true
        row.value = date
        self.form.addFormRow(row, afterRowTag: String(format: "%@(%@",Tags.ValidationDocumentNo, tag))
    }
    
    func removeExpiredDate(sender:NSNotification){
        
        let newTag = sender.userInfo!["tag"]!.componentsSeparatedByString("(")
        self.form.removeFormRowWithTag(String(format: "%@(%@",Tags.ValidationExpiredDate, newTag[1]))
        
    }
    
    func checkValidation() -> Bool{
        var countAdultAge = Int()
        var countMaxAdultAge = Int()
        var countInfantAge = Int()
        var countMaxInfantAge = Int()
        
        let currentDate: NSDate = NSDate()
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(name: "UTC")!
        
        for var i = 0; i < adultCount; i = i + 1{
            var count = i
            count++
            
            let selectDate: NSDate = stringToDate(formValues()[String(format: "%@(adult%i)", Tags.ValidationDate, count)]! as! String)
            
            let component: NSDateComponents = NSDateComponents()
            component.calendar = calendar
            component.year = -2
            let adultMinAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            component.year = -12
            let adultMaxAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            if selectDate.compare(stringToDate(formatDate(adultMinAge))) == NSComparisonResult.OrderedDescending{
                //age below 2 years old
                countAdultAge++
            }else if selectDate.compare(stringToDate(formatDate(adultMaxAge))) == NSComparisonResult.OrderedDescending{
                //age below 12 years old
                countMaxAdultAge++
            }
        }
        
        for var i = 0; i < infantCount; i = i + 1{
            
            var count = i
            count++
            
            let selectDate: NSDate = stringToDate(formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]! as! String)
            
            let component: NSDateComponents = NSDateComponents()
            component.calendar = calendar
            component.day = -9
            let infantMinAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            component.year = -2
            let infantMaxAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            if selectDate.compare(stringToDate(formatDate(infantMinAge))) == NSComparisonResult.OrderedDescending{
                //age below 9 days
                countInfantAge++
            }else if selectDate.compare(stringToDate(formatDate(infantMaxAge))) == NSComparisonResult.OrderedAscending{
                //age above 24months
                countMaxInfantAge++
            }
            
        }
        
        if countAdultAge > 0{
            showErrorMessage("Guest(s) must be above 2 years old at the date(s) of travel.")
            return false
        }else if countMaxAdultAge > 0 && adultCount == 1{
            showErrorMessage("There must be at least one(1) passenger above 12 years old at the date(s) of travel")
            return false
        }else if countMaxAdultAge > 0 && adultCount > 1{
            showErrorMessage("Passenger less than 12 years old must be accompanied by an 18 years old passenger.")
            return false
        }else if countInfantAge > 0 || countMaxInfantAge > 0{
            showErrorMessage("Infant(s) must be within the age of 9 days - 24 months at date(s) of travel.")
            return false
        }else{
            return true
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
