//
//  CustomFloatLabeledTextFieldCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/25/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import JVFloatLabeledTextField
import XLForm
import ActionSheetPicker_3_0

let XLFormRowDescriptorTypeCustomFloatLabeled = "XLFormRowDescriptorTypeCustomFloatLabeled"

class CustomFloatLabeledTextFieldCell: XLFormBaseCell {

    var data = [String]()
    var dataValue = [String]()
    var selectindex = Int()
    var selectValue = String()
    var expireDate = NSArray()
    var selectDateIndex = [0,0]
    
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
    
    
    //Mark: - XLFormDescriptorCell
    
    override func configure() {
        super.configure()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.contentView.addSubview(self.floatLabeledTextField)
        self.floatLabeledTextField.delegate = self
        contentView.addConstraints(layoutConstraints())
    }
    
    override func update() {
        super.update()
        if self.rowDescriptor?.tag == Tags.ValidationPassword || self.rowDescriptor?.tag == Tags.ValidationNewPassword || self.rowDescriptor?.tag == Tags.ValidationConfirmPassword{
            self.floatLabeledTextField.keyboardType = .ASCIICapable
            self.floatLabeledTextField.secureTextEntry = true
        }else if self.rowDescriptor?.tag == Tags.ValidationMobileHome || self.rowDescriptor?.tag == Tags.ValidationAlternate || self.rowDescriptor?.tag == Tags.ValidationPostcode || self.rowDescriptor?.tag == Tags.ValidationCcvNumber || self.rowDescriptor?.tag == Tags.ValidationCardNumber || self.rowDescriptor?.tag == Tags.ValidationEnrichLoyaltyNo{
            self.floatLabeledTextField.keyboardType = .PhonePad
        }
        
        self.floatLabeledTextField.attributedPlaceholder = NSAttributedString(string: self.rowDescriptor!.title ?? "" , attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        if let value: AnyObject = self.rowDescriptor!.value {
            self.floatLabeledTextField.text = value.displayText()
        }
        else {
            self.floatLabeledTextField.text = self.rowDescriptor!.noValueDisplayText
        }
        self.floatLabeledTextField.enabled = !self.rowDescriptor!.isDisabled()
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
        return 46
    }
    
    //var tags = XLFormRowDescriptor()
    //MARK: Helpers
    
    func layoutConstraints() -> [NSLayoutConstraint]{
        let views = ["floatLabeledTextField" : self.floatLabeledTextField]
        let metrics = ["hMargin": 25.0, "vMargin": 8.0]
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
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldClear(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true //self.formViewController().textFieldShouldReturn(textField)
    }
    
    /*func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if self.rowDescriptor!.tag == Tags.ValidationCardExpiredDate {
            return false
        }else if self.rowDescriptor!.tag == Tags.ValidationDeparting{
            
            tags.resignFirstResponder()
            tags.endEditing(true)
            
            retrieveData()
            let labelParagraphStyle = NSMutableParagraphStyle()
            labelParagraphStyle.alignment = .Center
            let picker = ActionSheetStringPicker(title: "", rows: data, initialSelection: selectindex, target: self, successAction: Selector("objectSelected:element:"), cancelAction: "actionPickerCancelled:", origin: textField)
            picker.pickerTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(25), NSParagraphStyleAttributeName : labelParagraphStyle]
            picker.showActionSheetPicker()
            
            return false
        }else{
            return true
        }
        
        
        //self.formViewController().textFieldShouldBeginEditing(textField)
    }
    */
    func textFieldDidBeginEditing(textField: UITextField) {
        if self.rowDescriptor!.tag == Tags.ValidationDeparting{
            self.formViewController().endEditing(self.rowDescriptor)//.resignFirstResponder()// .endEditing(self.rowDescriptor)
            //self.endEditing(true)
            //tags.resignFirstResponder()
            //tags.endEditing(true)
            //UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
            //textField.resignFirstResponder()
            //textField.endEditing(true)
        }else{
            //tags = textField
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return self.formViewController().textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.textFieldDidChange(textField)
    }

    func retrieveData(){
        data = [String]()
        dataValue = [String]()
        let row = self.rowDescriptor?.selectorOptions
        var i = 0
        for tempData in row!{
            data.append(tempData.formDisplayText())
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
            NSNotificationCenter.defaultCenter().postNotificationName("selectCountry", object: nil, userInfo: ["countryVal" : selectValue])
        }else if self.rowDescriptor?.tag == "Departing"{
            NSNotificationCenter.defaultCenter().postNotificationName("refreshArrivingCode", object: nil, userInfo: ["departStationCode" : selectValue])
            
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
