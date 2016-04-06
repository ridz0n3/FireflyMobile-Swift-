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
    @IBOutlet weak var continueBtn: UIButton!
    
    var adultCount = Int()
    var infantCount = Int()
    var adultArray = [Dictionary<String,AnyObject>]()
    
    var adultDetails = [Dictionary<String,AnyObject>]()
    var infantDetails = [Dictionary<String,AnyObject>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
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
    
    func getFormData()->([String:AnyObject], [String:AnyObject], String, String, Bool, Bool){
        var passenger = [String:AnyObject]()
        var passengerName = [String]()
        for var i = 0; i < adultCount; i = i + 1{
            var count = i
            count = count + 1
            var adultInfo = [String:AnyObject]()
            
            let name = "\(formValues()[String(format: "%@(adult%i)", Tags.ValidationTitle, count)] as! String, titleArr: titleArray) \(formValues()[String(format: "%@(adult%i)", Tags.ValidationFirstName, count)]!) \(formValues()[String(format: "%@(adult%i)", Tags.ValidationLastName, count)]!))"
            passengerName.append(name)
            
            adultInfo.updateValue(getTitleCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationTitle, count)] as! String, titleArr: titleArray), forKey: "title")
            adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationFirstName, count)]!, forKey: "first_name")
            adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationLastName, count)]!, forKey: "last_name")
            
            let date = formValues()[String(format: "%@(adult%i)", Tags.ValidationDate, count)]! as! String
            var arrangeDate = date.componentsSeparatedByString("-")
            
            adultInfo.updateValue("\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])", forKey: "dob")
            adultInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationTravelDoc, count)] as! String, docArr: travelDoc), forKey: "travel_document")
            adultInfo.updateValue(getCountryCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationCountry, count)] as! String, countryArr: countryArray), forKey: "issuing_country")
            adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationDocumentNo, count)]!.xmlSimpleEscapeString(), forKey: "document_number")
            
            let expiredDate = nilIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationExpiredDate, count)])! as! String
            var arrangeExpDate = NSArray()
            var newExpDate = String()
            
            if expiredDate != ""{
                arrangeExpDate = expiredDate.componentsSeparatedByString("-")
                newExpDate = "\(arrangeExpDate[2])-\(arrangeExpDate[1])-\(arrangeExpDate[0])"
            }
            
            adultInfo.updateValue(newExpDate, forKey: "expiration_date")
            adultInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, count)])!, forKey: "bonuslink")
            
            passenger.updateValue(adultInfo, forKey: "\(i)")
            
        }
        
        var travelWith = [String]()
        var infant = [String:AnyObject]()
        for var j = 0; j < infantCount; j = j + 1{
            var count = j
            count = count + 1
            var infantInfo = [String:AnyObject]()
            
            travelWith.append(getTravelWithCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelWith, count)] as! String, travelArr: adultArray))
            
            infantInfo.updateValue(getTravelWithCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelWith, count)] as! String, travelArr: adultArray), forKey: "traveling_with")
            infantInfo.updateValue(getGenderCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationGender, count)] as! String, genderArr: genderArray), forKey: "gender")
            infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationFirstName, count)]!, forKey: "first_name")
            infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationLastName, count)]!, forKey: "last_name")
            
            let date = formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]! as! String
            let arrangeDate = date.componentsSeparatedByString("-")
            
            infantInfo.updateValue("\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])", forKey: "dob")
            infantInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelDoc, count)] as! String, docArr: travelDoc), forKey: "travel_document")
            infantInfo.updateValue(getCountryCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationCountry, count)] as! String, countryArr: countryArray), forKey: "issuing_country")
            infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationDocumentNo, count)]!.xmlSimpleEscapeString(), forKey: "document_number")
            
            let expiredDate = nilIfEmpty(formValues()[String(format: "%@(infant%i)", Tags.ValidationExpiredDate, count)])! as! String
            var arrangeExpDate = NSArray()
            var newExpDate = String()
            
            if expiredDate != ""{
                arrangeExpDate = expiredDate.componentsSeparatedByString("-")
                newExpDate = "\(arrangeExpDate[2])-\(arrangeExpDate[1])-\(arrangeExpDate[0])"
            }
            
            infantInfo.updateValue(newExpDate, forKey: "expiration_date")
            
            infant.updateValue(infantInfo, forKey: "\(j)")
        }
        
        let bookId = String(format: "%i", defaults.objectForKey("booking_id")!.integerValue)
        let signature = defaults.objectForKey("signature") as! String
        defaults.setObject(infant, forKey: "infant")
        defaults.setObject(passenger, forKey: "passengerData")
        defaults.synchronize()
        
        let firstPassenger = passengerName[0]
        var nameDuplicate = Bool()
        for var i = 1; i < passengerName.count; i = i + 1{
            
            if passengerName[i] == firstPassenger{
                nameDuplicate = true
            }
            
        }
        
        var checkTravelWith = Bool()
        if travelWith.count != 0{
            
            let a = Array(Set(travelWith))
            
            if a.count == travelWith.count{
                checkTravelWith = true
            }
            
        }
        return (passenger, infant, bookId, signature, nameDuplicate, checkTravelWith)
    }
    
    func addExpiredDate(sender:NSNotification){
        let newTag = sender.userInfo!["tag"]!.componentsSeparatedByString("(")
        
        addExpiredDateRow(newTag[1], date: "")
        
    }
    
    func addExpiredDateRow(tag : String, date: String){
        
        var row : XLFormRowDescriptor
        
        // Date
        row = XLFormRowDescriptor(tag: String(format: "%@(%@", Tags.ValidationExpiredDate,tag), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Expiration Date:*")
        row.required = true
        
        if date != ""{
            row.value = formatDate(stringToDate(date))
        }
        //
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
            
            let date = formValues()[String(format: "%@(adult%i)", Tags.ValidationDate, count)]! as! String
            let arrangeDate = date.componentsSeparatedByString("-")
            
            let selectDate: NSDate = stringToDate("\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])")
            
            let component: NSDateComponents = NSDateComponents()
            component.calendar = calendar
            component.year = -2
            let adultMinAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            component.year = -12
            let adultMaxAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            let minAge = formatDate(adultMinAge)
            var arrangeMinAge = minAge.componentsSeparatedByString("-")
            let maxAge = formatDate(adultMaxAge)
            var arrangeMaxAge = maxAge.componentsSeparatedByString("-")
            
            if selectDate.compare(stringToDate("\(arrangeMinAge[2])-\(arrangeMinAge[1])-\(arrangeMinAge[0])")) == NSComparisonResult.OrderedDescending{
                //age below 2 years old
                countAdultAge++
            }else if selectDate.compare(stringToDate("\(arrangeMaxAge[2])-\(arrangeMaxAge[1])-\(arrangeMaxAge[0])")) == NSComparisonResult.OrderedDescending{
                //age below 12 years old
                countMaxAdultAge++
            }
        }
        
        for var i = 0; i < infantCount; i = i + 1{
            
            var count = i
            count++
            
            let date = formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]! as! String
            let arrangeDate = date.componentsSeparatedByString("-")
            
            let selectDate: NSDate = stringToDate("\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])")
            
            let component: NSDateComponents = NSDateComponents()
            component.calendar = calendar
            component.day = -9
            let infantMinAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            component.year = -2
            let infantMaxAge: NSDate = calendar.dateByAddingComponents(component, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            
            let minAge = formatDate(infantMinAge)
            var arrangeMinAge = minAge.componentsSeparatedByString("-")
            let maxAge = formatDate(infantMaxAge)
            var arrangeMaxAge = maxAge.componentsSeparatedByString("-")
            
            if selectDate.compare(stringToDate("\(arrangeMinAge[2])-\(arrangeMinAge[1])-\(arrangeMinAge[0])")) == NSComparisonResult.OrderedDescending{
                //age below 9 days
                countInfantAge++
            }else if selectDate.compare(stringToDate("\(arrangeMaxAge[2])-\(arrangeMaxAge[1])-\(arrangeMaxAge[0])")) == NSComparisonResult.OrderedAscending{
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
        }else if countMaxAdultAge == adultCount{
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
