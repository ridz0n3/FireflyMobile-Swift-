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
    
    var travelDoc = [["doc_code":"P","doc_name":"Passport"],["doc_code":"NRIC","doc_name":"Malaysia IC"],["doc_code":"VISA","doc_name":"Travel VISA"]]
    var genderArray = [["gender_code":"female","gender_name":"Female"],["gender_code":"male","gender_name":"Male"]]
    
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
        
        for var i = 0; i < adultCount; i = i + 1{
            var j = i
            j = j + 1
            
            let adultData:[String:String] = ["passenger_code":"Passenger_\(j)", "passenger_name":"Adult \(j)"]
            adultArray.addObject(adultData)
            // Basic Information - Section
            section = XLFormSectionDescriptor()
            section = XLFormSectionDescriptor.formSectionWithTitle("Adult \(j)")
            form.addFormSection(section)
            
            // Title
            
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTitle, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Title:*")
            
            var tempArray:[AnyObject] = [AnyObject]()
            titleArray = defaults.objectForKey("title") as! NSMutableArray
            for title in titleArray{
                tempArray.append(XLFormOptionsObject(value: title["title_code"], displayText: title["title_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            //first name
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationFirstName, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
            row.required = true
            section.addFormRow(row)
            
            //last name
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationLastName, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
            row.required = true
            section.addFormRow(row)
            
            // Date
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDate, j), rowType:XLFormRowDescriptorTypeFloatLabeledDatePicker, title:"Date of Birth:*")
            row.required = true
            section.addFormRow(row)
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationTravelDoc, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Travel Document:*")
            
            tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"], displayText: travel["doc_name"]))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationCountry, j), rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Nationality:*")
            
            tempArray = [AnyObject]()
            countryArray = defaults.objectForKey("country") as! NSMutableArray
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationDocumentNo, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Document No:*")
            row.required = true
            section.addFormRow(row)
            
            // Enrich Loyalty No
            row = XLFormRowDescriptor(tag: String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, j), rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Enrich Loyalty No:")
            section.addFormRow(row)

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

    @IBAction func continuePaymentBtnPressed(sender: AnyObject) {
        validateForm()
        
        
        if isValidate{
            
            var passenger = [AnyObject]()
            for var i = 0; i < adultCount; i = i + 1{
                var count = i
                count = count + 1
                var adultInfo = [String:AnyObject]()
                
                adultInfo.updateValue(getTitleCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationTitle, count)] as! String), forKey: "title")
                adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationFirstName, count)]!, forKey: "first_name")
                adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationLastName, count)]!, forKey: "last_name")
                adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationDate, count)]!, forKey: "dob")
                adultInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationTravelDoc, count)] as! String), forKey: "travel_document")
                adultInfo.updateValue(getCountryCode(formValues()[String(format: "%@(adult%i)", Tags.ValidationFirstName, count)] as! String), forKey: "issuing_country")
                adultInfo.updateValue(formValues()[String(format: "%@(adult%i)", Tags.ValidationDocumentNo, count)]!, forKey: "document_no")
                adultInfo.updateValue(nilIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationExpiredDate, count)])!, forKey: "expiration_date")
                adultInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(adult%i)", Tags.ValidationEnrichLoyaltyNo, count)])!, forKey: "enrich_loyalty_no")
                
                passenger.append(adultInfo)
                //passenger.updateValue(adultInfo, forKey: "passenger_\(count)")
                
            }
            
            var infant = [AnyObject]()
            for var j = 0; j < infantCount; j = j + 1{
                var count = j
                count = count + 1
                var infantInfo = [String:AnyObject]()
                
                infantInfo.updateValue(getTravelWithCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelWith, count)] as! String), forKey: "traveling_with")
                infantInfo.updateValue(getGenderCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationGender, count)] as! String), forKey: "gender")
                infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationFirstName, count)]!, forKey: "first_name")
                infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationLastName, count)]!, forKey: "last_name")
                infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationDate, count)]!, forKey: "dob")
                infantInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationTravelDoc, count)] as! String), forKey: "travel_document")
                infantInfo.updateValue(getCountryCode(formValues()[String(format: "%@(infant%i)", Tags.ValidationCountry, count)] as! String), forKey: "issuing_country")
                infantInfo.updateValue(formValues()[String(format: "%@(infant%i)", Tags.ValidationDocumentNo, count)]!, forKey: "document_no")
                infantInfo.updateValue(nilIfEmpty(formValues()[String(format: "%@(infant%i)", Tags.ValidationExpiredDate, count)])!, forKey: "expiration_date")
                
                infant.append(infantInfo)
                //infant.updateValue(infantInfo, forKey: "infant_\(count)")
            }
            
            FireFlyProvider.request(.PassengerDetail(passenger,infant), completion: { (result) -> () in
                
                switch result {
                case .Success(let successResult):
                    do {
                        
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentVC") as! PaymentViewController
                        //self.navigationController!.pushViewController(paymentVC, animated: true)
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

    @IBAction func continueChooseSeatBtnPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
        let chooseSeatVC = storyboard.instantiateViewControllerWithIdentifier("ChooseSeatVC") as! ChooseSeatViewController
        self.navigationController!.pushViewController(chooseSeatVC, animated: true)
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
                showToastMessage("Please fill all fields")
                
            }
        }else{
            isValidate = true
        }
    }
    
    func addExpiredDate(sender:NSNotification){
        print(sender.userInfo!["tag"])
        
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
    
    func getTitleCode(titleName:String)->String{
        var titleCode = String()
        for titleData in titleArray{
            if titleData["title_name"] as! String == titleName{
                titleCode = titleData["title_code"] as! String
            }
        }
        return titleCode
    }
    
    func getCountryCode(countryName:String)->String{
        var countryCode = String()
        for countryData in countryArray{
            if countryData["country_name"] as! String == countryName{
                countryCode = countryData["country_code"] as! String
            }
        }
        return countryCode
    }
    
    func getTravelDocCode(docName:String)->String{
        var docCode = String()
        for docData in travelDoc{
            if docData["doc_name"] == docName{
                docCode = docData["doc_code"]!
            }
        }
        return docCode
    }
    
    func getTravelWithCode(travelName:String)->String{
        var travelCode = String()
        for travelData in adultArray{
            if travelData["passenger_name"] as! String == travelName{
                travelCode = travelData["passenger_code"] as! String
            }
        }
        return travelCode
    }
    
    func getGenderCode(genderName:String)-> String{
        var genderCode = String()
        for genderData in genderArray{
            if genderData["gender_name"] == genderName{
                genderCode = genderData["gender_code"]!
            }
        }
        return genderCode
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
