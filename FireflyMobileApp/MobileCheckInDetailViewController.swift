//
//  MobileCheckInDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/3/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import M13Checkbox
import SwiftyJSON

class MobileCheckInDetailViewController: BaseXLFormViewController {
    
    var checkInDetail = Dictionary<String, AnyObject>()
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var seatNo: UILabel!
    @IBOutlet weak var checkBox: M13Checkbox!
    @IBOutlet weak var passengerName: UIView!
    @IBOutlet weak var flightDate: UILabel!
    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var stationCode: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var checkStatus: UILabel!
    var pnr = String()
    
    var arr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.mobileCheckInDetailScreen)
        continueBtn.layer.cornerRadius = 10
        
        detailTableView.estimatedRowHeight = 80
        detailTableView.rowHeight = UITableViewAutomaticDimension
        
        let flightDetail = checkInDetail["flight_detail"] as! Dictionary<String, AnyObject>
        stationCode.text = "\(flightDetail["station_code"] as! String)"
        flightDate.text = "\(flightDetail["flight_date"] as! String)"
        flightNumber.text = "\(flightDetail["flight_number"] as! String)"
        time.text = "\(flightDetail["departure_time"] as! String)"
        // Do any additional setup after loading the view.
        initializeForm()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MobileCheckInDetailViewController.addExpiredDate(_:)), name: "expiredDate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MobileCheckInDetailViewController.removeExpiredDate(_:)), name: "removeExpiredDate", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        
        var i = 0
        var countNotCheckIn = 0
        for passengerData in checkInDetail["passengers"] as! [Dictionary<String,AnyObject>] {
            
            section = XLFormSectionDescriptor()
            form.addFormSection(section)
            
            if passengerData["status"] as! String == "Checked In"{
                arr.append("Check In")
            }else{
                arr.append("false")
                countNotCheckIn += 1
            }
            
            
            // Travel Document
            row = XLFormRowDescriptor(tag: String(format: "%@(%i)", Tags.ValidationTravelDoc, i), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Travel Document:*")
            
            var tempArray = [AnyObject]()
            for travel in travelDoc{
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"] as! String, displayText: travel["doc_name"] as! String))
                
                if passengerData["travel_document"] as? String == travel["doc_code"] as? String{
                    row.value = travel["doc_name"]
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Country
            row = XLFormRowDescriptor(tag: String(format: "%@(%i)", Tags.ValidationCountry, i), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Issuing Country:*")
            
            tempArray = [AnyObject]()
            for country in countryArray{
                tempArray.append(XLFormOptionsObject(value: country["country_code"], displayText: country["country_name"] as! String))
                
                if passengerData["issuing_country"] as? String == country["country_code"] as? String{
                    row.value = country["country_name"] as! String
                }
            }
            
            row.selectorOptions = tempArray
            row.required = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(%i)", Tags.ValidationDocumentNo, i), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Document No:*")
            row.required = true
            //row.value = (passengerData["document_number"] as! String).xmlSimpleUnescapeString()
            section.addFormRow(row)
            
            // Enrich Loyalty No
            row = XLFormRowDescriptor(tag: String(format: "%@(%i)", Tags.ValidationEnrichLoyaltyNo, i), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
            //row.value = passengerData["document_number"] as! String
            section.addFormRow(row)
            
            i += 1
        }
        
        self.form = form
        
        if countNotCheckIn == 0{
            continueBtn.hidden = true
        }
        var j = 0
        for passengerData in checkInDetail["passengers"] as! [Dictionary<String,AnyObject>] {
            
            let expiredDate = (passengerData["expiration_date"] as! String).componentsSeparatedByString("T")
            if passengerData["travel_document"] as! String == "P"{
                addExpiredDateRow("\(j))", date: expiredDate[0])
            }
            j += 1
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if arr[indexPath.section] == "true"{
            return 50
        }else{
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        passengerName = NSBundle.mainBundle().loadNibNamed("MobileCheckInView", owner: self, options: nil)[0] as! UIView
        
        let passengerDataArray = checkInDetail["passengers"] as! [Dictionary<String, AnyObject>]
        let passengerData = passengerDataArray[section] 
        name.text = "\(getTitleName(passengerData["title"] as! String)) \(passengerData["first_name"] as! String) \(passengerData["last_name"] as! String)"
        seatNo.text = passengerData["seat"]! as? String
        checkBtn.tag = section
        checkBox.strokeColor = UIColor.orangeColor()
        checkBox.checkColor = UIColor.orangeColor()
        
        checkBtn.addTarget(self, action: #selector(MobileCheckInDetailViewController.check(_:)), forControlEvents: .TouchUpInside)
        
        if passengerData["status"] as! String == "Checked In"{
            checkBox.hidden = true
            checkStatus.hidden = false
            checkBtn.hidden = true
        }else{
            checkBox.hidden = false
            checkStatus.hidden = true
            checkBtn.hidden = false
        }
        
        if arr[section] == "true"{
            checkBox.checkState = M13CheckboxState.Checked
        }else{
            checkBox.checkState = M13CheckboxState.Unchecked
        }
        
        return passengerName
        
    }
    
    func check(sender : UIButton){
        var i = 0
        
        for arrData in arr{
            
            if i == sender.tag{
                
                if arrData == "true"{
                    arr.removeAtIndex(i)
                    arr.insert("false", atIndex: i)
                }else{
                    arr.removeAtIndex(i)
                    arr.insert("true", atIndex: i)
                }
                
            }
            i += 1
            
        }
        detailTableView.beginUpdates()
        detailTableView.endUpdates()
        detailTableView.reloadData()
        //checkBox.checkState = M13CheckboxState.Checked
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        var checkData = 0
        var allDataCount = 0
        for arrData in arr{
            if arrData == "true"{
                validatedForm("\(allDataCount))")
                checkData += 1
            }
            allDataCount += 1
        }
        
        if checkData == 0{
            showErrorMessage("No passenger selected.")
        }else{
            
            if !isValidate{
                showErrorMessage("Please filled all field")
            }else{
                var passenger = [String:AnyObject]()
                var count = 0
                for data in arr{
                    if data == "true"{
                        var passengerInfo = [String:AnyObject]()
                        var passengerArray = [AnyObject]()
                        passengerInfo.updateValue("Y", forKey: "status")
                        passengerArray = checkInDetail["passengers"] as! [AnyObject]
                        passengerInfo.updateValue(passengerArray[count]["passenger_number"]!!, forKey: "passenger_number")
                        passengerInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(%i)", Tags.ValidationTravelDoc, count)] as! String, docArr: travelDoc), forKey: "travel_document")
                        passengerInfo.updateValue(getCountryCode(formValues()[String(format: "%@(%i)", Tags.ValidationCountry, count)] as! String, countryArr: countryArray), forKey: "issuing_country")
                        passengerInfo.updateValue(formValues()[String(format: "%@(%i)", Tags.ValidationDocumentNo, count)]!.xmlSimpleEscapeString(), forKey: "document_number")
                        
                        let expiredDate = nilIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationExpiredDate, count)])! as! String
                        var arrangeExpDate = NSArray()
                        var newExpDate = String()
                        
                        if expiredDate != ""{
                            arrangeExpDate = expiredDate.componentsSeparatedByString("-")
                            newExpDate = "\(arrangeExpDate[2])-\(arrangeExpDate[1])-\(arrangeExpDate[0])"
                        }
                        
                        passengerInfo.updateValue(newExpDate, forKey: "expiration_date")
                        
                        passengerInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationEnrichLoyaltyNo, count)])!, forKey: "bonuslink")
                        
                        passenger.updateValue(passengerInfo, forKey: "\(count)")
                    }else{
                        var passengerInfo = [String:AnyObject]()
                        var passengerArray = [AnyObject]()
                        passengerInfo.updateValue("N", forKey: "status")
                        passengerArray = checkInDetail["passengers"] as! [AnyObject]
                        passengerInfo.updateValue(passengerArray[count]["passenger_number"]!!, forKey: "passenger_number")
                        passenger.updateValue(passengerInfo, forKey: "\(count)")
                    }
                    count += 1
                }
                
                let signature = checkInDetail["signature"] as! String
                let departure_station_code = checkInDetail["departure_station_code"] as! String
                let arrival_station_code = checkInDetail["arrival_station_code"] as! String

                showLoading() 
                FireFlyProvider.request(.CheckInPassengerList(pnr, departure_station_code, arrival_station_code, signature, passenger), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if  json["status"].string == "success"{
                                
                                let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                                let checkInDetailVC = storyboard.instantiateViewControllerWithIdentifier("MobileCheckInTermVC") as! MobileCheckInTermViewController
                                checkInDetailVC.pnr = self.pnr
                                checkInDetailVC.termDetail = json.object as! Dictionary<String, AnyObject> 
                                self.navigationController!.pushViewController(checkInDetailVC, animated: true)
                                
                            }else if json["status"].string == "401"{
                                hideLoading()
                                showErrorMessage(json["message"].string!)
                                InitialLoadManager.sharedInstance.load()
                                
                                for views in (self.navigationController?.viewControllers)!{
                                    if views.classForCoder == HomeViewController.classForCoder(){
                                        self.navigationController?.popToViewController(views, animated: true)
                                        AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                    }
                                }
                            }else{
                                
                                showErrorMessage(json["message"].string!)
                            }
                            hideLoading()
                        }
                        catch {
                            
                        }
                        
                    case .Failure(let failureResult):
                        hideLoading()
                        showErrorMessage(failureResult.nsError.localizedDescription)
                    }
                })
                
            }
            
        }
    }
    
    func validatedForm(index:String) {
        let array = formValidationErrors()
        
        if array.count != 0{
            
            var count = 0
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let errorTag = validationStatus.rowDescriptor!.tag!.componentsSeparatedByString("(")
                //isValidate = false
                
                if errorTag[1] == index{
                    count += 1
                    if errorTag[0] == Tags.ValidationCountry || errorTag[0] == Tags.ValidationTravelDoc {
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! CustomFloatLabelCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                        
                        
                    }else if errorTag[0] == Tags.ValidationExpiredDate{
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! CustomFloatLabelCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                    }else{
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! CustomFloatLabelCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                    }
                    
                }
            }
            
            if count == 0{
                isValidate = true
            }else{
                isValidate = false
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
        row = XLFormRowDescriptor(tag: String(format: "%@(%@", Tags.ValidationExpiredDate,tag), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Expiration Date:*")
        row.required = true
        
        if date == ""{
            row.value =  ""
        }else{
            let dateArr = date.componentsSeparatedByString("-")
            let arrangeDate = "\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"
            row.value =  arrangeDate
        }
        
        self.form.addFormRow(row, afterRowTag: String(format: "%@(%@",Tags.ValidationDocumentNo, tag))
    }
    
    func removeExpiredDate(sender:NSNotification){
        
        let newTag = sender.userInfo!["tag"]!.componentsSeparatedByString("(")
        self.form.removeFormRowWithTag(String(format: "%@(%@",Tags.ValidationExpiredDate, newTag[1]))
        
    }
}
