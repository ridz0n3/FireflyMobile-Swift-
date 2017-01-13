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
        
        NotificationCenter.default.addObserver(self, selector: #selector(MobileCheckInDetailViewController.addExpiredDate(_:)), name: NSNotification.Name(rawValue: "expiredDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MobileCheckInDetailViewController.removeExpiredDate(_:)), name: NSNotification.Name(rawValue: "removeExpiredDate"), object: nil)
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
                tempArray.append(XLFormOptionsObject(value: travel["doc_code"]!, displayText: travel["doc_name"]!))
                
                if passengerData["travel_document"]! as! String == travel["doc_code"]!{
                    row.value = travel["doc_name"]
                }
            }
            
            row.selectorOptions = tempArray
            row.isRequired = true
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
            row.isRequired = true
            section.addFormRow(row)
            
            // Document Number
            row = XLFormRowDescriptor(tag: String(format: "%@(%i)", Tags.ValidationDocumentNo, i), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Document No:*")
            row.isRequired = true
            //row.value = (passengerData["document_number"] as! String).xmlSimpleUnescape
            section.addFormRow(row)
            
            // Bonuslink Number
            row = XLFormRowDescriptor(tag: String(format: "%@(%i)", Tags.ValidationBonuslinkNo, i), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"BonusLink Card No:")
            //row.addValidator(XLFormRegexValidator(msg: "Bonuslink number is invalid", andRegexString: "^6018[0-9]{12}$"))
            row.value = nullIfEmpty(passengerData["bonuslink"] as AnyObject)
            section.addFormRow(row)
            
            // Enrich Loyalty Number
            row = XLFormRowDescriptor(tag: String(format: "%@(%i)", Tags.ValidationEnrichLoyaltyNo, i), rowType: XLFormRowDescriptorTypeFloatLabeled, title:"Enrich Loyalty Number:")
            row.value = nullIfEmpty(passengerData["enrich"] as AnyObject)
            section.addFormRow(row)
            
            i += 1
        }
        
        self.form = form
        
        if countNotCheckIn == 0{
            continueBtn.isHidden = true
        }
        var j = 0
        for passengerData in checkInDetail["passengers"] as! [Dictionary<String,AnyObject>] {
            
            let expiredDate = (passengerData["expiration_date"] as! String).components(separatedBy: "T")
            if passengerData["travel_document"] as! String == "P"{
                addExpiredDateRow("\(j))", date: expiredDate[0])
            }
            j += 1
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if arr[indexPath.section] == "true"{
            return 50
        }else{
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        passengerName = Bundle.main.loadNibNamed("MobileCheckInView", owner: self, options: nil)?[0] as! UIView
        
        let passengerDataArray = checkInDetail["passengers"] as! [Dictionary<String, AnyObject>]
        let passengerData = passengerDataArray[section] 
        name.text = "\(getTitleName(passengerData["title"] as! String)) \(passengerData["first_name"] as! String) \(passengerData["last_name"] as! String)"
        seatNo.text = passengerData["seat"]! as? String
        checkBtn.tag = section
        checkBox.strokeColor = UIColor.orange
        checkBox.checkColor = UIColor.orange
        
        checkBtn.addTarget(self, action: #selector(MobileCheckInDetailViewController.check(_:)), for: .touchUpInside)
        
        if passengerData["status"] as! String == "Checked In"{
            checkBox.isHidden = true
            checkStatus.isHidden = false
            checkBtn.isHidden = true
        }else{
            checkBox.isHidden = false
            checkStatus.isHidden = true
            checkBtn.isHidden = false
        }
        
        if arr[section] == "true"{
            checkBox.checkState = M13CheckboxState.checked
        }else{
            checkBox.checkState = M13CheckboxState.unchecked
        }
        
        return passengerName
        
    }
    
    func check(_ sender : UIButton){
        var i = 0
        
        for arrData in arr{
            
            if i == sender.tag{
                
                if arrData == "true"{
                    arr.remove(at: i)
                    arr.insert("false", at: i)
                }else{
                    arr.remove(at: i)
                    arr.insert("true", at: i)
                }
                
            }
            i += 1
            
        }
        detailTableView.beginUpdates()
        detailTableView.endUpdates()
        detailTableView.reloadData()
        //checkBox.checkState = M13CheckboxState.checked
    }
    
    @IBAction func continueBtnPressed(_ sender: AnyObject) {
        
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
                var wrongEnrichNo = [Bool]()
                var wrongBonuslinkNo = [Bool]()
                var bonuslinkArr = [String]()
                var enrichArr = [String]()
                var enrichNo = String()
                var bonuslinkNo = String()
                
                var passenger = [String:AnyObject]()
                var count = 0
                for data in arr{
                    if data == "true"{
                        var passengerInfo = [String:AnyObject]()
                        var passengerArray = [AnyObject]()
                        
                        passengerInfo.updateValue("Y" as AnyObject, forKey: "status")
                        passengerArray = checkInDetail["passengers"] as! [AnyObject]
                        let passengerNum = passengerArray[count] as! NSDictionary
                        passengerInfo.updateValue(passengerNum["passenger_number"]! as AnyObject, forKey: "passenger_number")
                        passengerInfo.updateValue(getTravelDocCode(formValues()[String(format: "%@(%i)", Tags.ValidationTravelDoc, count)] as! String, docArr: travelDoc as [Dictionary<String, AnyObject>]) as AnyObject, forKey: "travel_document")
                        passengerInfo.updateValue(getCountryCode(formValues()[String(format: "%@(%i)", Tags.ValidationCountry, count)] as! String, countryArr: countryArray) as AnyObject, forKey: "issuing_country")
                        passengerInfo.updateValue((formValues()[String(format: "%@(%i)", Tags.ValidationDocumentNo, count)]! as! String).xmlSimpleEscape as AnyObject, forKey: "document_number")
                        
                        let expiredDate = nullIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationExpiredDate, count)] as AnyObject)
                        var arrangeExpDate = [String]()
                        var newExpDate = String()
                        
                        if expiredDate != ""{
                            arrangeExpDate = expiredDate.components(separatedBy: "-")
                            newExpDate = "\(arrangeExpDate[2])-\(arrangeExpDate[1])-\(arrangeExpDate[0])"
                        }
                        
                        passengerInfo.updateValue(newExpDate as AnyObject, forKey: "expiration_date")
                        
                        if nullIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationBonuslinkNo, count)] as AnyObject) != ""{
                            
                            let bonusLink = nullIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationBonuslinkNo, count)] as AnyObject)
                            
                            let patern = "^6018[0-9]{12}$"
                            
                            if bonusLink.range(of:patern, options: .regularExpression) != nil {
                                
                                passengerInfo.updateValue(bonusLink as AnyObject, forKey: "bonuslink")
                                
                            }else{
                                wrongBonuslinkNo.append(false)
                                bonuslinkArr.append(bonusLink)
                            }

                            
                        }else{
                            passengerInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationBonuslinkNo, count)] as AnyObject) as AnyObject, forKey: "bonuslink")
                        }
                        
                        if nullIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationEnrichLoyaltyNo, count)] as AnyObject) != ""{
                            
                            let loyaltyNo = nullIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationEnrichLoyaltyNo, count)] as AnyObject).uppercased()
                            
                            let patern = "MH[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"
                            
                            if let range = loyaltyNo.range(of:patern, options: .regularExpression) {
                                let result = loyaltyNo.substring(with:range)
                                
                                let subStr = result.components(separatedBy: "MH")
                                let cStr = subStr[1]
                                
                                let startIndex = cStr.index(cStr.startIndex, offsetBy: 0)
                                let endIndex = cStr.index(cStr.startIndex, offsetBy: 7)
                                
                                let cRange = cStr[startIndex...endIndex]
                                
                                let c = Int(cRange)! % 7
                                
                                let kIndex = cStr.index(cStr.startIndex, offsetBy: 8)
                                let k = cStr[kIndex...kIndex]
                                
                                if Int(k)! != c{
                                    wrongEnrichNo.append(false)
                                    enrichArr.append(loyaltyNo)
                                }else{
                                    passengerInfo.updateValue(loyaltyNo as AnyObject, forKey: "enrich")
                                }
                                
                            }else{
                                wrongEnrichNo.append(false)
                                enrichArr.append(loyaltyNo)
                            }
                            
                        }else{
                            passengerInfo.updateValue(nullIfEmpty(formValues()[String(format: "%@(%i)", Tags.ValidationEnrichLoyaltyNo, count)] as AnyObject) as AnyObject, forKey: "enrich")
                        }
                        
                        passenger.updateValue(passengerInfo as AnyObject, forKey: "\(count)")
                        
                    }else{
                        var passengerInfo = [String:AnyObject]()
                        var passengerArray = [AnyObject]()
                        passengerInfo.updateValue("N" as AnyObject, forKey: "status")
                        passengerArray = checkInDetail["passengers"] as! [AnyObject]
                        let passengerNum = passengerArray[count] as! NSDictionary
                        passengerInfo.updateValue(passengerNum["passenger_number"]! as AnyObject, forKey: "passenger_number")
                        passenger.updateValue(passengerInfo as AnyObject, forKey: "\(count)")
                    }
                    count += 1
                }
                
                let signature = checkInDetail["signature"] as! String
                let departure_station_code = checkInDetail["departure_station_code"] as! String
                let arrival_station_code = checkInDetail["arrival_station_code"] as! String

                var bonuslinkNoCheck = Bool()
                if wrongBonuslinkNo.count != 0{
                    bonuslinkNoCheck = true
                }
                
                var j = 1
                for data in bonuslinkArr{
                    
                    if bonuslinkArr.count == 1 || bonuslinkArr.count == j{
                        bonuslinkNo.append("\(data) ")
                    }else{
                        bonuslinkNo.append("\(data), ")
                    }
                    
                    j += 1
                }
                
                var enrichNoCheck = Bool()
                if wrongEnrichNo.count != 0{
                    enrichNoCheck = true
                }
                
                var i = 1
                for data in enrichArr{
                    
                    if enrichArr.count == 1 || enrichArr.count == i{
                        enrichNo.append("\(data) ")
                    }else{
                        enrichNo.append("\(data), ")
                    }
                    
                    i += 1
                }
                
                if bonuslinkNoCheck{
                    showErrorMessage("Bonuslink number \(bonuslinkNo)is invalid.")
                }else if enrichNoCheck{
                    showErrorMessage("Enrich loyalty number \(enrichNo)is invalid.")
                }else{
                    
                    showLoading()
                    FireFlyProvider.request(.CheckInPassengerList(pnr, departure_station_code, arrival_station_code, signature, passenger as AnyObject), completion: { (result) -> () in
                        
                        switch result {
                        case .success(let successResult):
                            do {
                                let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                                
                                if  json["status"].string == "success"{
                                    
                                    let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
                                    let checkInDetailVC = storyboard.instantiateViewController(withIdentifier: "MobileCheckInTermVC") as! MobileCheckInTermViewController
                                    checkInDetailVC.pnr = self.pnr
                                    checkInDetailVC.termDetail = json.object as! Dictionary<String, AnyObject>
                                    self.navigationController!.pushViewController(checkInDetailVC, animated: true)
                                    
                                }else if json["status"].string == "401"{
                                    hideLoading()
                                    showErrorMessage(json["message"].string!)
                                    InitialLoadManager.sharedInstance.load()
                                    
                                    for views in (self.navigationController?.viewControllers)!{
                                        if views.classForCoder == HomeViewController.classForCoder(){
                                            _ = self.navigationController?.popToViewController(views, animated: true)
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
                            
                        case .failure(let failureResult):
                            hideLoading()
                            showErrorMessage(failureResult.localizedDescription)
                        }
                    })
                    
                }
                
            }
            
        }
    }
    
    func validatedForm(_ index:String) {
        let array = formValidationErrors()
        
        if array?.count != 0{
            
            var count = 0
            for errorItem in array! {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let errorTag = validationStatus.rowDescriptor!.tag!.components(separatedBy: "(")
                //isValidate = false
                
                if errorTag[1] == index{
                    count += 1
                    if errorTag[0] == Tags.ValidationCountry || errorTag[0] == Tags.ValidationTravelDoc {
                        let index = self.form.indexPath(ofFormRow: validationStatus.rowDescriptor!)! as IndexPath
                        
                        if self.tableView.cellForRow(at: index) != nil{
                            let cell = self.tableView.cellForRow(at: index) as! CustomFloatLabelCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.red])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                        
                        
                    }else if errorTag[0] == Tags.ValidationExpiredDate{
                        let index = self.form.indexPath(ofFormRow: validationStatus.rowDescriptor!)! as IndexPath
                        
                        if self.tableView.cellForRow(at: index) != nil{
                            let cell = self.tableView.cellForRow(at: index) as! CustomFloatLabelCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.red])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                    }else{
                        let index = self.form.indexPath(ofFormRow: validationStatus.rowDescriptor!)! as IndexPath
                        
                        if self.tableView.cellForRow(at: index) != nil{
                            let cell = self.tableView.cellForRow(at: index) as! CustomFloatLabelCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.red])
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
    
    func addExpiredDate(_ sender:NSNotification){
        let newTag = (sender.userInfo!["tag"]! as AnyObject).components(separatedBy: "(")
        
        addExpiredDateRow(newTag[1], date: "")
        
    }
    
    func addExpiredDateRow(_ tag : String, date: String){
        
        var row : XLFormRowDescriptor
        
        // Date
        row = XLFormRowDescriptor(tag: String(format: "%@(%@", Tags.ValidationExpiredDate,tag), rowType:XLFormRowDescriptorTypeFloatLabeled, title:"Expiration Date:*")
        row.isRequired = true
        
        if date == ""{
            row.value =  ""
        }else{
            let dateArr = date.components(separatedBy: "-")
            let arrangeDate = "\(dateArr[2])-\(dateArr[1])-\(dateArr[0])"
            row.value =  arrangeDate
        }
        
        self.form.addFormRow(row, afterRowTag: String(format: "%@(%@",Tags.ValidationDocumentNo, tag))
    }
    
    func removeExpiredDate(_ sender:NSNotification){
        
        let newTag = (sender.userInfo!["tag"]! as AnyObject).components(separatedBy: "(")
        self.form.removeFormRow(withTag: String(format: "%@(%@",Tags.ValidationExpiredDate, newTag[1]))
        
    }
}
