//
//  PassengerDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/7/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON

class PassengerDetailViewController: BaseXLFormViewController {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var titleArray = NSMutableArray()
    var countryArray = NSMutableArray()
    var adultCount = Int()
    var infantCount = Int()
    
    var travelDoc = [["doc_code":"P","doc_name":"Passport"],["doc_code":"NRIC","doc_name":"Malaysia IC"],["doc_code":"V","doc_name":"Travel VISA"]]
    var genderArray = [["gender_code":"Female","gender_name":"Female"],["gender_code":"Male","gender_name":"Male"]]
    
    var adultArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        setupLeftButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addExpiredDate:", name: "expiredDate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeExpiredDate:", name: "removeExpiredDate", object: nil)
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
        
        adultArray = NSMutableArray()
        adultCount = (defaults.objectForKey("adult")?.integerValue)!
        infantCount = (defaults.objectForKey("infant")?.integerValue)!
        
        if try! !LoginManager.sharedInstance.isLogin(){
           /* section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Member Login (Optional)")
            form.addFormSection(section)
            
            //first name
            row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"User ID(Email):*")
            row.addValidator(XLFormValidator.emailValidator())
            row.required = true
            section.addFormRow(row)
            
            //last name
            row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Password:*")
            row.required = true
            section.addFormRow(row)
            */
            
        }
        
        for adult in 1...adultCount{
            
            var i = adult
            i--
            
            let adultData:[String:String] = ["passenger_code":"\(i)", "passenger_name":"Adult \(adult)"]
            adultArray.addObject(adultData)
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Adult \(adult)")
            form.addFormSection(section)
            
            
            if try! LoginManager.sharedInstance.isLogin() && adult == 1 {
                
                // Title
                
                let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
                
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Title:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
                titleArray = defaults.objectForKey("title") as! NSMutableArray
                for title in titleArray{
                    tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
                    
                    if title["title_code"] as! String == userInfo["title"] as! String{
                        row.value = title["title_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                //first name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
                row.required = true
                row.value = "\(userInfo["first_name"]!)"
                section.addFormRow(row)
                
                //last name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
                row.required = true
                row.value = "\(userInfo["last_name"]!)"
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
                row.value = "\(userInfo["DOB"]!)"
                row.required = true
                section.addFormRow(row)
                
                // Travel Document
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
                
                tempArray = [AnyObject]()
                for travel in travelDoc{
                    tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // Country
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Nationality:*")
                
                tempArray = [AnyObject]()
                countryArray = defaults.objectForKey("country") as! NSMutableArray
                for country in countryArray{
                    tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                    
                    if country["country_code"] as! String == userInfo["contact_country"] as! String{
                        row.value = country["country_name"] as! String
                    }
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // Document Number
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
                row.required = true
                section.addFormRow(row)
                
                // Enrich Loyalty No
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Enrich Loyalty No:")
                section.addFormRow(row)
                
            }else{
                // Title
                
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Title:*")
                
                var tempArray:[AnyObject] = [AnyObject]()
                titleArray = defaults.objectForKey("title") as! NSMutableArray
                for title in titleArray{
                    tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                //first name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
                row.required = true
                section.addFormRow(row)
                
                //last name
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
                row.required = true
                section.addFormRow(row)
                
                // Date
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, adult), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
                row.required = true
                section.addFormRow(row)
                
                // Travel Document
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
                
                tempArray = [AnyObject]()
                for travel in travelDoc{
                    tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // Country
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, adult), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Nationality:*")
                
                tempArray = [AnyObject]()
                countryArray = defaults.objectForKey("country") as! NSMutableArray
                for country in countryArray{
                    tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                }
                
                row.selectorOptions = tempArray
                row.required = true
                section.addFormRow(row)
                
                // Document Number
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
                row.required = true
                section.addFormRow(row)
                
                // Enrich Loyalty No
                row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, adult), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Enrich Loyalty No:")
                section.addFormRow(row)
            }
            
        }
        
        for var i = 0; i < infantCount; i = i + 1{
                var j = i
                j = j + 1

            
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Infant \(j)")
            form.addFormSection(section)
            
            // Title
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelWith, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Traveling with:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            for passenger in adultArray{
                tempArray.append(XLFormOptionsObject(value: passenger["passenger_code"], displayText: passenger["passenger_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Gender
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationGender, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Gender:*")
            
            tempArray = [AnyObject]()
            for gender in genderArray{
                tempArray.append(XLFormOptionsObject(value: gender["gender_code"], displayText: gender["gender_name"]))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // First name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationFirstName, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
            row.required = true
            section.addFormRow(row)
            
            // Last Name
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationLastName, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
            row.required = true
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDate, j), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
            row.required = true
            section.addFormRow(row)
            
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationTravelDoc, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
            
            tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationCountry, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Nationality:*")
            
            tempArray = [AnyObject]()
            countryArray = defaults.objectForKey("country") as! NSMutableArray
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(infant%i)", Tags.ValidationDocumentNo, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
            row.required = true
            section.addFormRow(row)
        }
        
        self.form = form
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
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
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
                showToastMessage("Guest(s) must be above 2 years old at the date(s) of travel.")
            }else if countMaxAdultAge > 0 && adultCount == 1{
                showToastMessage("There must be at least one(1) passenger above 12 years old at the date(s) of travel")
            }else if countMaxAdultAge > 0 && adultCount > 1{
                showToastMessage("Passenger less than 12 years old must be accompanied by an 18 years old passenger.")
            }else if countInfantAge > 0 || countMaxInfantAge > 0{
                showToastMessage("Infant(s) must be within the age of 9 days - 24 months at date(s) of travel.")
            }else{
                let params = getFormData()
                
                showHud()
                
                FireFlyProvider.request(.PassengerDetail(params.0,params.1,params.2, params.3), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            self.hideHud()
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                self.showToastMessage(json["status"].string!)
                                
                                if json["insurance"].object["status"] as! String == "N"{
                                    self.defaults.setObject("", forKey: "insurance_status")
                                }else{
                                    self.defaults.setObject(json["insurance"].object, forKey: "insurance_status")
                                    self.defaults.synchronize()
                                }
                                
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let contactDetailVC = storyboard.instantiateViewControllerWithIdentifier("ContactDetailVC") as! ContactDetailViewController
                                self.navigationController!.pushViewController(contactDetailVC, animated: true)
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
            }
        }
        
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
