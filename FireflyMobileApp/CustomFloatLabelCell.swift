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
import Crashlytics

let XLFormRowDescriptorTypeFloatLabeled = "XLFormRowDescriptorTypeFloatLabeled"
var textFieldBefore = UITextField()


class CustomFloatLabelCell: XLFormBaseCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //picker
    var data = [String]()
    var dataValue = [String]()
    var selectindex = Int()
    var selectValue = String()
    var expireDate = [[String]]()
    var selectDateIndex = [0,0]
    
    //date picker
    var selectDate = Date()
    let pickerView = UIPickerView()
    
    func addToolBar(_ textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CustomFloatLabelCell.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CustomFloatLabelCell.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed(){
        
        floatLabeledTextField.text = data[selectindex]
        floatLabeledTextField.resignFirstResponder()
        
        if selectValue == "P"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeExpiredDate"), object: nil, userInfo: ["tag" : (self.rowDescriptor?.tag)!])
        }else if selectValue == "2"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBusiness"), object: nil)
        }
        
        //selectindex = selectindex
        selectValue = dataValue[selectindex]
        
        if selectValue == "P"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "expiredDate"), object: nil, userInfo: ["tag" : (self.rowDescriptor?.tag)!])
        }else if selectValue == "2"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addBusiness"), object: nil)
        }else if self.rowDescriptor?.tag == "Country"{
            var dialingCode = String()
            for country in countryArray{
                
                if country["country_code"] as! String == selectValue{
                    dialingCode = country["dialing_code"] as! String
                }
                
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectCountry"), object: nil, userInfo: ["countryVal" : selectValue, "dialingCode" : dialingCode])
        }else if self.rowDescriptor?.tag == "Departing"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshArrivingCode"), object: nil, userInfo: ["departStationCode" : selectValue])
            
        }
        
    }
    
    func cancelPressed(){
        floatLabeledTextField.endEditing(true) // or do something
    }
    
    static let kFontSize : CGFloat = 14.0
    lazy var floatLabeledTextField: JVFloatLabeledTextField  = {
        let result  = JVFloatLabeledTextField(frame: CGRect.zero)
        result.background = UIImage(named: "txtField")
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: kFontSize)
        result.floatingLabel.font = UIFont.boldSystemFont(ofSize: kFontSize)
        result.clearButtonMode = UITextFieldViewMode.whileEditing
        return result
    }()
    
    override func configure() {
        selectindex = 0
        super.configure()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.addSubview(self.floatLabeledTextField)
        self.floatLabeledTextField.delegate = self
        contentView.addConstraints(layoutConstraints())
    }
    
    override func update() {
        super.update()
        
        let tag = self.rowDescriptor?.tag?.components(separatedBy: "(")
        
        if tag![0] == "Password" || tag![0] == "New Password" || tag![0] == "Confirm Password"{
            self.floatLabeledTextField.keyboardType = .asciiCapable
            self.floatLabeledTextField.isSecureTextEntry = true
        }else if tag![0] == "Mobile/Home" || tag![0] == "Alternate" || tag![0] == "Postcode" || tag![0] == "CCV/CVC Number" || tag![0] == "Card Number" || tag![0] == "Bonuslink" || tag![0] == Tags.ValidationFax{
            self.floatLabeledTextField.keyboardType = .phonePad
        }else if tag![0] == Tags.ValidationPurpose
            || tag![0] == Tags.ValidationState
            || tag![0] == Tags.ValidationCardType
            || tag![0] == Tags.ValidationArriving
            || tag![0] == Tags.ValidationDeparting
            || tag![0] == Tags.ValidationTitle
            || tag![0] == Tags.ValidationCountry
            || tag![0] == Tags.ValidationTravelDoc
            || tag![0] == Tags.ValidationTravelWith
            || tag![0] == Tags.ValidationGender
            || tag![0] == Tags.ValidationSSRList{
            addToolBar(self.floatLabeledTextField)
        }
        
        if tag![0] != Tags.ValidationEnrichLoyaltyNo{
            let title = self.rowDescriptor!.title?.components(separatedBy: ":")
            let star = [NSForegroundColorAttributeName : UIColor.red]
            var attrString = NSMutableAttributedString()
            attrString = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title![0]):"))
            if (title?.count)! >= 2{
                let attrStar = NSMutableAttributedString(string: title![1], attributes: star)
                attrString.append(attrStar)
            }
            
            self.floatLabeledTextField.attributedPlaceholder = attrString
        }else{
            self.floatLabeledTextField.placeholder = self.rowDescriptor!.title
        }
        
        if let value: AnyObject = self.rowDescriptor!.value as AnyObject? {
            self.floatLabeledTextField.text = value.displayText()
        }
        else {
            self.floatLabeledTextField.text = self.rowDescriptor!.noValueDisplayText
        }
        self.floatLabeledTextField.isEnabled = !self.rowDescriptor!.isDisabled()
        self.floatLabeledTextField.textColor = self.rowDescriptor!.isDisabled() ? UIColor.lightGray : UIColor.black
        self.floatLabeledTextField.floatingLabelTextColor = UIColor.lightGray
        self.floatLabeledTextField.alpha = self.rowDescriptor!.isDisabled() ? 0.6 : 1.0
        
    }
    
    override func formDescriptorCellCanBecomeFirstResponder() -> Bool {
        return !self.rowDescriptor!.isDisabled()
    }
    
    override func formDescriptorCellBecomeFirstResponder() -> Bool {
        return self.floatLabeledTextField.becomeFirstResponder()
    }
    
    override static func formDescriptorCellHeight(for rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 55
    }
    
    //MARK: Helper
    func layoutConstraints() -> [NSLayoutConstraint]{
        let views = ["floatLabeledTextField" : self.floatLabeledTextField]
        let metrics = ["hMargin": 15.0, "vMargin": 8.0]
        var result =  NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hMargin)-[floatLabeledTextField]-(hMargin)-|", options:NSLayoutFormatOptions.alignAllCenterY, metrics:metrics, views:views)
        result += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|", options:NSLayoutFormatOptions.alignAllCenterX, metrics:metrics, views:views)
        return result
    }
    
    func textFieldDidChange(_ textField : UITextField) {
        if self.floatLabeledTextField == textField {
            if self.floatLabeledTextField.text!.isEmpty == false {
                self.rowDescriptor!.value = self.floatLabeledTextField.text
            } else {
                self.rowDescriptor!.value = nil
            }
        }
    }
    
    //Mark: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let tag = self.rowDescriptor?.tag?.components(separatedBy: "(")
        
        if tag![0] == Tags.ValidationCardExpiredDate{
            textFieldBefore.endEditing(true)
            getExpiredData()
            let labelParagraphStyle = NSMutableParagraphStyle()
            labelParagraphStyle.alignment = .center
            ActionSheetMultipleStringPicker.show(withTitle: "", rows: expireDate as [AnyObject], initialSelection: selectDateIndex as [AnyObject], target: self, successAction: #selector(CustomFloatLabelCell.expiredDateSelected(_:element:)), cancelAction: nil, origin: textField)
            return false
        }else if tag![0] == Tags.ValidationDate || tag![0] == Tags.ValidationExpiredDate{
            textFieldBefore.endEditing(true)
            
            if self.rowDescriptor?.value as! String != ""{
                
                let date = self.rowDescriptor?.value
                let dateArr = (date as! String).replacingOccurrences(of: "-", with: "/")
                let formater = DateFormatter()
                formater.dateStyle = DateFormatter.Style.short
                let twentyFour = Locale(identifier: "en_GB")
                formater.locale = twentyFour as Locale!
                selectDate = formater.date(from: dateArr)!
            }
            
            let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.date , selectedDate: selectDate, target: self, action: #selector(CustomFloatLabelCell.datePicked(_:element:)), origin: textField)
            
            if let str = self.rowDescriptor.tag{
                
                let strArr = str.components(separatedBy: "(")
                
                if strArr[0] == Tags.ValidationExpiredDate{
                    datePicker?.minimumDate = Date()
                    CLSLogv("Log %@", getVaList([strArr[0]]))
                }else{
                    datePicker?.maximumDate = Date()
                }
                
            }
            
            
            
            datePicker?.show()
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
            || tag![0] == Tags.ValidationGender
            || tag![0] == Tags.ValidationSSRList{
            
            //textFieldBefore.endEditing(true)
            retrieveData()
            /*
             let labelParagraphStyle = NSMutableParagraphStyle()
             labelParagraphStyle.alignment = .Center
             let picker = ActionSheetStringPicker(title: "", rows: data, initialSelection: selectindex, target: self, successAction: #selector(CustomFloatLabelCell.objectSelected(_:element:)), cancelAction: "actionPickerCancelled:", origin: textField)
             picker.pickerTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(25), NSParagraphStyleAttributeName : labelParagraphStyle]
             picker.showActionSheetPicker()
             */
            
            pickerView.delegate = self
            self.pickerView.selectRow(selectindex, inComponent: 0, animated: true)
            floatLabeledTextField.inputView = pickerView
            return true
        }else{
            textFieldBefore = textField
            return true
        }
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldClear(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
    
        let doc = self.rowDescriptor?.tag?.components(separatedBy: "(")
        if self.rowDescriptor?.tag == Tags.ValidationConfirmationNumber{
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if self.rowDescriptor?.tag == Tags.ValidationCcvNumber{
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if doc![0] == Tags.ValidationDocumentNo{
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return self.formViewController().textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
                data.append("\((tempData as AnyObject).formDisplayText()) (\((tempData as AnyObject).valueData() as! (String)))")
            }else{
                data.append((tempData as AnyObject).formDisplayText())
            }
            
            dataValue.append((tempData as AnyObject).valueData() as! (String))
            
            if ((self.rowDescriptor?.value) != nil){
                if self.rowDescriptor?.value as! String == (tempData as AnyObject).formDisplayText(){
                    selectindex = i
                    selectValue = (tempData as AnyObject).valueData() as! (String)
                }
            }
            
            i += 1
        }
    }
    
    func expiredDateSelected(_ index:NSArray, element:AnyObject){
        
        let txtLbl = element as! UITextField
        
        let monthIndex = index[0]
        let yearIndex = index[1]
        
        selectDateIndex = [(monthIndex as AnyObject).integerValue, (yearIndex as AnyObject).integerValue]
        
        txtLbl.text = "\(expireDate[0][(monthIndex as AnyObject).integerValue])/\(expireDate[1][(yearIndex as AnyObject).integerValue])"
        self.textFieldDidChange(txtLbl)
        
    }
    
    func objectSelected(index :NSNumber, element:AnyObject){
        
        let txtLbl = element as! UITextField
        
        if selectValue == "P"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeExpiredDate"), object: nil, userInfo: ["tag" : (self.rowDescriptor?.tag)!])
        }else if selectValue == "2"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBusiness"), object: nil)
        }
        
        selectindex = index.intValue
        selectValue = dataValue[index.intValue]
        
        txtLbl.text = data[index.intValue]
        self.textFieldDidChange(txtLbl)
        
        if selectValue == "P"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "expiredDate"), object: nil, userInfo: ["tag" : (self.rowDescriptor?.tag)!])
        }else if selectValue == "2"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addBusiness"), object: nil)
        }else if self.rowDescriptor?.tag == "Country"{
            var dialingCode = String()
            for country in countryArray{
                
                if country["country_code"] as! String == selectValue{
                    dialingCode = country["dialing_code"] as! String
                }
                
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectCountry"), object: nil, userInfo: ["countryVal" : selectValue, "dialingCode" : dialingCode])
        }else if self.rowDescriptor?.tag == "Departing"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshArrivingCode"), object: nil, userInfo: ["departStationCode" : selectValue])
            
        }
        
    }
    
    func getExpiredData(){
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy"
        let currentYear = formater.string(from: Date())
        var yearInc = Int(currentYear)
        
        var year = [String]()
        for _ in 0...10{
            
            year.append("\(yearInc!)")
            yearInc = yearInc! + 1
            
        }
        
        var month = [String]()
        for i in 1...12{
            if i < 10{
                month.append("0\(i)")
            }else{
                month.append("\(i)")
            }
        }
        
        expireDate = [month, year]
        
    }
    
    //Mark : Date picker function
    func formatDate(_ date:Date) -> String{
        
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        return formater.string(from: date)
        
    }
    
    func datePicked(_ date: Date, element:AnyObject){
        
        let textLbl = element as! UITextField
        selectDate = date
        textLbl.text = formatDate(date)
        self.textFieldDidChange(textLbl)
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        floatLabeledTextField.text = data[row]
        floatLabeledTextField.resignFirstResponder()
        
        if selectValue == "P"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeExpiredDate"), object: nil, userInfo: ["tag" : (self.rowDescriptor?.tag)!])
        }else if selectValue == "2"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeBusiness"), object: nil)
        }
        
        selectindex = row
        selectValue = dataValue[row]
        
        if selectValue == "P"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "expiredDate"), object: nil, userInfo: ["tag" : (self.rowDescriptor?.tag)!])
        }else if selectValue == "2"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addBusiness"), object: nil)
        }else if self.rowDescriptor?.tag == "Country"{
            var dialingCode = String()
            for country in countryArray{
                
                if country["country_code"] as! String == selectValue{
                    dialingCode = country["dialing_code"] as! String
                }
                
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectCountry"), object: nil, userInfo: ["countryVal" : selectValue, "dialingCode" : dialingCode])
        }else if self.rowDescriptor?.tag == "Departing"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshArrivingCode"), object: nil, userInfo: ["departStationCode" : selectValue])
            
        }
        
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
