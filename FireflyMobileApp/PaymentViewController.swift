//
//  PaymentViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/31/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox
import XLForm
import SwiftyJSON

class PaymentViewController: BaseXLFormViewController {
    
    var totalDue = Int()
    var paymentType = NSArray()
    var cardType = NSMutableArray()
    var paymentMethod = String()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var totalDueLbl: UILabel!
    @IBOutlet weak var creditCardCheckBox: M13Checkbox!
    @IBOutlet weak var onlineBankingCheckBox: M13Checkbox!
    @IBOutlet weak var cashCheckBox: M13Checkbox!
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        setupLeftButton()
        creditCardCheckBox.checkState = M13CheckboxStateChecked
        paymentMethod = "Card"
        creditCardCheckBox.addTarget(self, action: "check:", forControlEvents: .TouchUpInside)
        onlineBankingCheckBox.addTarget(self, action: "check:", forControlEvents: .TouchUpInside)
        cashCheckBox.addTarget(self, action: "check:", forControlEvents: .TouchUpInside)
        
        totalDueLbl.text = "\(totalDue) MYR"
        rearrangePaymentType()
        initializeForm()
        
        // Do any additional setup after loading the view.
    }
    
    func rearrangePaymentType(){
        
        var xchannelPosition : CGFloat = 41
        var xonlinePosition : CGFloat = 41
        var xcashPosition : CGFloat = 41
        
        for channel in paymentType{
            
            let url = NSURL(string: channel["channel_logo"] as! String)!
            let data = NSData(contentsOfURL: url)
            
            if channel["channel_type"] as! Int == 1{
                
                let img = UIImageView(frame: CGRectMake(xchannelPosition, 309, 68, 42))
                img.image = UIImage(data: data!)
                img.contentMode = .ScaleAspectFit
                headerView.addSubview(img)
                
                xchannelPosition = xchannelPosition + 70
                
                cardType.addObject(channel)
                
            }else if channel["channel_type"] as! Int == 2{
                
                let img = UIImageView(frame: CGRectMake(xonlinePosition, 362, 68, 42))
                img.contentMode = .ScaleToFill
                img.image = UIImage(data: data!)
                headerView.addSubview(img)
                
                xonlinePosition = xonlinePosition + 70
                
            }else{
                
                let img = UIImageView(frame: CGRectMake(xcashPosition, 418, 68, 42))
                img.contentMode = .ScaleToFill
                
                if (data != nil){
                    img.image = UIImage(data: data!)
                    headerView.addSubview(img)
                }
                
                xcashPosition = xcashPosition + 70
                
            }
            
        }
    }
    
    @IBAction func checkBtn(sender: AnyObject) {
        
        let btn = sender as! UIButton
        
        if btn.tag == 1{
            creditCardCheckBox.checkState = M13CheckboxStateChecked
            onlineBankingCheckBox.checkState = M13CheckboxStateUnchecked
            cashCheckBox.checkState = M13CheckboxStateUnchecked
            self.form.formRowWithTag(Tags.HideSection)?.value = "notHide"
            tableView.reloadData()
            paymentMethod = "Card"
        }else if btn.tag == 2{
            creditCardCheckBox.checkState = M13CheckboxStateUnchecked
            onlineBankingCheckBox.checkState = M13CheckboxStateChecked
            cashCheckBox.checkState = M13CheckboxStateUnchecked
            self.form.formRowWithTag(Tags.HideSection)?.value = "hide"
            tableView.reloadData()
            paymentMethod = "Online Banking"
        }else{
            creditCardCheckBox.checkState = M13CheckboxStateUnchecked
            onlineBankingCheckBox.checkState = M13CheckboxStateUnchecked
            cashCheckBox.checkState = M13CheckboxStateChecked
            self.form.formRowWithTag(Tags.HideSection)?.value = "hide"
            tableView.reloadData()
            paymentMethod = "Cash"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        let section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        section = XLFormSectionDescriptor()
        section.hidden = "$\(Tags.HideSection).value contains 'hide'"
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.HideSection, rowType: XLFormRowDescriptorTypeText, title:"")
        row.hidden = true
        row.value = "notHide"
        section.addFormRow(row)

        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationCardType, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Card Type:*")
        
        var tempArray = [AnyObject]()
        for cType in cardType{
            tempArray.append(XLFormOptionsObject(value: cType["channel_code"], displayText: cType["channel_name"] as! String))
        }
        
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        //card number
        row = XLFormRowDescriptor(tag: Tags.ValidationCardNumber, rowType: XLFormRowDescriptorTypeFloatLabeledPhoneNumber, title:"Card Number:*")
        row.required = true
        section.addFormRow(row)
        
        // Title
        row = XLFormRowDescriptor(tag: Tags.ValidationCardExpiredDate, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Expiration Date:*")
        
        row.required = true
        section.addFormRow(row)
        
        //holder name
        row = XLFormRowDescriptor(tag: Tags.ValidationHolderName, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Holder Name:*")
        row.required = true
        section.addFormRow(row)
        
        //CVV/CVC Number
        row = XLFormRowDescriptor(tag: Tags.ValidationCcvNumber, rowType: XLFormRowDescriptorTypeFloatLabeledPhoneNumber, title:"CVV/CVC Number:*")
        row.required = true
        section.addFormRow(row)

        self.form = form
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        if paymentMethod == "Card"{
        
            validateForm()
            
            if isValidate{
                let cardNumber = self.formValues()[Tags.ValidationCardNumber] as! String
                
                if !luhnCheck(cardNumber){
                    self.showToastMessage("Invalid credit card")
                }else if !checkDate(self.formValues()[Tags.ValidationCardExpiredDate] as! String){
                    self.showToastMessage("Invalid Date")
                }else{
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let signature = defaults.objectForKey("signature") as! String
                    let channelType = "1"
                    let channelCode = getCardTypeCode(self.formValues()[Tags.ValidationCardType] as! String, cardArr: cardType)
                    let cardHolderName = self.formValues()[Tags.ValidationHolderName] as! String
                    let cvv = self.formValues()[Tags.ValidationCcvNumber] as! String
                    let expiredDate = (self.formValues()[Tags.ValidationCardExpiredDate] as! String).componentsSeparatedByString("/")
                    let issuingBank = self.formValues()[Tags.ValidationCardType] as! String
                    let expirationDateMonth = expiredDate[0]
                    let expirationDateYear = expiredDate[1]
                    
                    
                    showHud()
                    FireFlyProvider.request(.PaymentProcess(signature, channelType, channelCode, cardNumber, expirationDateMonth, expirationDateYear, cardHolderName, issuingBank, cvv), completion: { (result) -> () in
                        
                        self.hideHud()
                        switch result {
                        case .Success(let successResult):
                            do {
                                self.hideHud()
                                let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                
                                if json["status"] == "Redirect"{
                                    self.showToastMessage(json["status"].string!)
                                    
                                    let pass = json["pass"].string?.componentsSeparatedByString("/")
                                    let urlString = String(format: "%@/%@%@", json["link"].string!,pass![0],pass![1])
                                    let url = NSURL(string: urlString)
                                    print(url)
                                    
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
    }
    
    func getCardTypeCode(cardName:String, cardArr:NSArray)->String{
        var cardCode = String()
        for cardData in cardArr{
            if cardData["channel_name"] as! String == cardName{
                cardCode = cardData["channel_code"] as! String
            }
        }
        return cardCode
    }
    
    func checkDate(date:String) -> Bool{
        
        let currentDate = date.componentsSeparatedByString("/")
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        let monthString = formatter.stringFromDate(NSDate())
        formatter.dateFormat = "yyyy"
        let yearString = formatter.stringFromDate(NSDate())
        
        
        if currentDate[1] == yearString{
            if Int(currentDate[0]) <= Int(monthString){
                return false
            }
        }
        
        return true
    
    }
    
    func luhnCheck(number: String) -> Bool {
        var sum = 0
        let reversedCharacters = number.characters.reverse().map { String($0) }
        for (idx, element) in reversedCharacters.enumerate() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    override func validateForm() {
        let array = formValidationErrors()
        
        if array.count != 0{
            isValidate = false
            
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let errorTag = validationStatus.rowDescriptor!.tag!
                
                if errorTag == Tags.ValidationCardType ||
                    errorTag == Tags.ValidationCardExpiredDate {
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledPickerCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                        
                        
                }else if errorTag == Tags.ValidationCardNumber || errorTag == Tags.ValidationCcvNumber{
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
                //showToastMessage("Please fill all fields")
                
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
