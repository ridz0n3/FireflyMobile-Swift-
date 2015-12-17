//
//  FloatLabeledPickerCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/8/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import JVFloatLabeledTextField
import ActionSheetPicker_3_0

let XLFormRowDescriptorTypeFloatLabeledPicker = "XLFormRowDescriptorTypeFloatLabeledPicker"

class FloatLabeledPickerCell: XLFormBaseCell{
    
    var data = [String]()
    var dataValue = [String]()
    var selectindex = Int()
    var selectValue = String()
    
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
        selectindex = 0
        super.configure()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.contentView.addSubview(self.floatLabeledTextField)
        self.floatLabeledTextField.delegate = self
        contentView.addConstraints(layoutConstraints())
    }
    
    override func update() {
        super.update()
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
    
    //Mark: UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        retrieveData()
        
        let labelParagraphStyle = NSMutableParagraphStyle()
        labelParagraphStyle.alignment = .Center
        let picker = ActionSheetStringPicker(title: "", rows: data, initialSelection: selectindex, target: self, successAction: Selector("objectSelected:element:"), cancelAction: "actionPickerCancelled:", origin: textField)
        picker.pickerTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(25), NSParagraphStyleAttributeName : labelParagraphStyle]
        picker.showActionSheetPicker()

        return false
    }
    
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
                self.rowDescriptor!.value = self.floatLabeledTextField.text //selectValue
            } else {
                self.rowDescriptor!.value = nil
            }
        }
    }
    
    func retrieveData(){
        data = [String]()
        dataValue = [String]()
        let row = self.rowDescriptor?.selectorOptions
        for tempData in row!{
            data.append(tempData.formDisplayText())
            dataValue.append(tempData.valueData() as! (String))
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
