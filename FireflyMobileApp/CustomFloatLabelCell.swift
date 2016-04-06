//
//  CustomFloatLabelCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 4/4/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import JVFloatLabeledTextField
import ActionSheetPicker_3_0

let XLFormRowDescriptorTypeFloatLabeled = "XLFormRowDescriptorTypeFloatLabeled"
var textFieldBefore = UITextField()

class CustomFloatLabelCell: XLFormBaseCell, UITextFieldDelegate {

    //picker
    var data = [String]()
    var dataValue = [String]()
    var selectindex = Int()
    var selectValue = String()
    var expireDate = NSArray()
    var selectDateIndex = [0,0]
    
    //date picker
    var selectDate = NSDate()
    
    static let kFontSize : CGFloat = 14.0
    lazy var floatLabeledTextField: JVFloatLabeledTextField  = {
        let result  = JVFloatLabeledTextField(frame: CGRect.zero)
        result.background = UIImage(named: "txtField")
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFontOfSize(kFontSize)
        result.floatingLabel.font = UIFont.boldSystemFontOfSize(kFontSize)
        result.clearButtonMode = UITextFieldViewMode.WhileEditing
        return result
    }()
    
    override func configure() {
        selectindex = 0
        super.configure()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.contentView.addSubview(self.floatLabeledTextField)
        self.floatLabeledTextField.delegate = self
        contentView.addConstraints(layoutConstraints())
    }
    
    override func update() {
        super.update()
        
        let tag = self.rowDescriptor?.tag?.componentsSeparatedByString("(")
        
        if tag![0] == "Password" || tag![0] == "New Password" || tag![0] == "Confirm Password"{
            self.floatLabeledTextField.keyboardType = .ASCIICapable
            self.floatLabeledTextField.secureTextEntry = true
        }else if tag![0] == "Mobile/Home" || tag![0] == "Alternate" || tag![0] == "Postcode" || tag![0] == "CCV/CVC Number" || tag![0] == "Card Number" || tag![0] == "Bonuslink" || tag![0] == Tags.ValidationFax{
            self.floatLabeledTextField.keyboardType = .PhonePad
        }
        
        if tag![0] != Tags.ValidationEnrichLoyaltyNo{
            let title = self.rowDescriptor!.title?.componentsSeparatedByString(":")
            let star = [NSForegroundColorAttributeName : UIColor.redColor()]
            var attrString = NSMutableAttributedString()
            attrString = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title![0]):"))
            if title?.count >= 2{
                let attrStar = NSMutableAttributedString(string: title![1], attributes: star)
                attrString.appendAttributedString(attrStar)
            }
            
            self.floatLabeledTextField.attributedPlaceholder = attrString
        }else{
            self.floatLabeledTextField.placeholder = self.rowDescriptor!.title
        }
        
        if let value: AnyObject = self.rowDescriptor!.value {
            self.floatLabeledTextField.text = value.displayText()
        }
        else {
            self.floatLabeledTextField.text = self.rowDescriptor!.noValueDisplayText
        }
        self.floatLabeledTextField.enabled = !self.rowDescriptor!.isDisabled()
        self.floatLabeledTextField.textColor = self.rowDescriptor!.isDisabled() ? UIColor.lightGrayColor() : UIColor.blackColor()
        self.floatLabeledTextField.floatingLabelTextColor = UIColor.lightGrayColor()
        self.floatLabeledTextField.alpha = self.rowDescriptor!.isDisabled() ? 0.6 : 1.0
        
    }
    
    override func formDescriptorCellCanBecomeFirstResponder() -> Bool {
        return !self.rowDescriptor!.isDisabled()
    }
    
    override func formDescriptorCellBecomeFirstResponder() -> Bool {
        return self.floatLabeledTextField.becomeFirstResponder()
    }
    
    override static func formDescriptorCellHeightForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 55
    }
    
    //MARK: Helper
    func layoutConstraints() -> [NSLayoutConstraint]{
        let views = ["floatLabeledTextField" : self.floatLabeledTextField]
        let metrics = ["hMargin": 15.0, "vMargin": 8.0]
        var result =  NSLayoutConstraint.constraintsWithVisualFormat("H:|-(hMargin)-[floatLabeledTextField]-(hMargin)-|", options:NSLayoutFormatOptions.AlignAllCenterY, metrics:metrics, views:views)
        result += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|", options:NSLayoutFormatOptions.AlignAllCenterX, metrics:metrics, views:views)
        return result
    }

    func textFieldDidChange(textField : UITextField) {
        if self.floatLabeledTextField == textField {
            if self.floatLabeledTextField.text!.isEmpty == false {
                self.rowDescriptor!.value = self.floatLabeledTextField.text
            } else {
                self.rowDescriptor!.value = nil
            }
        }
    }
    
    //Mark: UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let tag = self.rowDescriptor?.tag?.componentsSeparatedByString("(")
        
        if tag![0] == Tags.ValidationCardExpiredDate{
            textFieldBefore.endEditing(true)
            getExpiredData()
            let labelParagraphStyle = NSMutableParagraphStyle()
            labelParagraphStyle.alignment = .Center
            ActionSheetMultipleStringPicker.showPickerWithTitle("", rows: expireDate as [AnyObject], initialSelection: selectDateIndex as [AnyObject], target: self, successAction: Selector("expiredDateSelected:element:"), cancelAction: nil, origin: textField)
            return false
        }else if tag![0] == Tags.ValidationDate || tag![0] == Tags.ValidationExpiredDate{
            textFieldBefore.endEditing(true)
            let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.Date , selectedDate: selectDate, target: self, action: "datePicked:element:", origin: textField)
            
            let str = self.rowDescriptor?.tag?.componentsSeparatedByString("(")
            
            if str![0] == "Expiration Date"{
                datePicker.minimumDate = NSDate()
            }else{
                datePicker.maximumDate = NSDate()
            }
            
            datePicker.showActionSheetPicker()
            return false
        }else if tag![0] == Tags.ValidationPurpose
            || tag![0] == Tags.ValidationState
            || tag![0] == Tags.ValidationCardType
            || tag![0] == Tags.ValidationArriving
            || tag![0] == Tags.ValidationDeparting
            || tag![0] == Tags.ValidationTitle
            || tag![0] == Tags.ValidationCountry
            || tag![0] == Tags.ValidationTravelDoc
            || tag![0] == Tags.ValidationTravelWith
            || tag![0] == Tags.ValidationGender{
            
            textFieldBefore.endEditing(true)
            retrieveData()
            let labelParagraphStyle = NSMutableParagraphStyle()
            labelParagraphStyle.alignment = .Center
            let picker = ActionSheetStringPicker(title: "", rows: data, initialSelection: selectindex, target: self, successAction: Selector("objectSelected:element:"), cancelAction: "actionPickerCancelled:", origin: textField)
            picker.pickerTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(25), NSParagraphStyleAttributeName : labelParagraphStyle]
            picker.showActionSheetPicker()
            return false
        }else{
            textFieldBefore = textField
            return true
        }
        
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldClear(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let doc = self.rowDescriptor?.tag?.componentsSeparatedByString("(")
        if self.rowDescriptor?.tag == Tags.ValidationConfirmationNumber{
            let maxLength = 6
            let currentString: NSString = textField.text!
            let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }else if self.rowDescriptor?.tag == Tags.ValidationCcvNumber{
            let maxLength = 4
            let currentString: NSString = textField.text!
            let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }else if doc![0] == Tags.ValidationDocumentNo{
            let maxLength = 20
            let currentString: NSString = textField.text!
            let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }else{
            return self.formViewController().textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.textFieldDidChange(textField)
    }
    
    //Mark : Picker function
    func retrieveData(){
        data = [String]()
        dataValue = [String]()
        let row = self.rowDescriptor?.selectorOptions
        var i = 0
        for tempData in row!{
            
            if self.rowDescriptor?.tag == Tags.ValidationDeparting || self.rowDescriptor?.tag == Tags.ValidationArriving{
                data.append("\(tempData.formDisplayText()) (\(tempData.valueData() as! (String)))")
            }else{
                data.append(tempData.formDisplayText())
            }
            
            dataValue.append(tempData.valueData() as! (String))
            
            if ((self.rowDescriptor?.value) != nil){
                if self.rowDescriptor?.value as! String == tempData.formDisplayText(){
                    selectindex = i
                    selectValue = tempData.valueData() as! (String)
                }
            }
            
            i++
        }
    }
    
    func expiredDateSelected(index:NSArray, element:AnyObject){
        
        let txtLbl = element as! UITextField
        
        let monthIndex = index[0]
        let yearIndex = index[1]
        
        selectDateIndex = [monthIndex.integerValue, yearIndex.integerValue]
        txtLbl.text = "\(expireDate[0][monthIndex.integerValue])/\(expireDate[1][yearIndex.integerValue])"
        self.textFieldDidChange(txtLbl)
        
    }
    
    func objectSelected(index :NSNumber, element:AnyObject){
        
        let txtLbl = element as! UITextField
        
        if selectValue == "P"{
            NSNotificationCenter.defaultCenter().postNotificationName("removeExpiredDate", object: nil, userInfo: ["tag" : (self.rowDescriptor?.tag)!])
        }else if selectValue == "2"{
            NSNotificationCenter.defaultCenter().postNotificationName("removeBusiness", object: nil)
        }
        
        selectindex = index.integerValue
        selectValue = dataValue[index.integerValue]
        
        txtLbl.text = data[index.integerValue]
        self.textFieldDidChange(txtLbl)
        
        if selectValue == "P"{
            NSNotificationCenter.defaultCenter().postNotificationName("expiredDate", object: nil, userInfo: ["tag" : (self.rowDescriptor?.tag)!])
        }else if selectValue == "2"{
            NSNotificationCenter.defaultCenter().postNotificationName("addBusiness", object: nil)
        }else if self.rowDescriptor?.tag == "Country"{
            var dialingCode = String()
            for country in countryArray{
                
                if country["country_code"] as! String == selectValue{
                    dialingCode = country["dialing_code"] as! String
                }
                
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("selectCountry", object: nil, userInfo: ["countryVal" : selectValue, "dialingCode" : dialingCode])
        }else if self.rowDescriptor?.tag == "Departing"{
            NSNotificationCenter.defaultCenter().postNotificationName("refreshArrivingCode", object: nil, userInfo: ["departStationCode" : selectValue])
            
        }
        
    }
    
    func getExpiredData(){
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy"
        let currentYear = formater.stringFromDate(NSDate())
        var yearInc = Int(currentYear)
        
        let year = NSMutableArray()
        for _ in 0...10{
            
            year.addObject("\(yearInc!)")
            yearInc = yearInc! + 1
            
        }
        
        let month = NSMutableArray()
        for i in 1...12{
            if i < 10{
                month.addObject("0\(i)")
            }else{
                month.addObject("\(i)")
            }
        }
        
        expireDate = [month, year]
        
    }
    
    //Mark : Date picker function
    func formatDate(date:NSDate) -> String{
        
        let formater = NSDateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        return formater.stringFromDate(date)
        
    }
    
    func datePicked(date:NSDate, element:AnyObject){
        
        let textLbl = element as! UITextField
        selectDate = date
        textLbl.text = formatDate(date)
        self.textFieldDidChange(textLbl)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
