//
//  FloateLabeledDatePickerCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/8/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import JVFloatLabeledTextField
import ActionSheetPicker_3_0

let XLFormRowDescriptorTypeFloatLabeledDatePicker = "XLFormRowDescriptorTypeFloatLabeledDatePicker"

class FloateLabeledDatePickerCell: XLFormBaseCell {
    
    var data = [String]()
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
        let title = self.rowDescriptor!.title?.componentsSeparatedByString(":")
        
        let star = [NSForegroundColorAttributeName : UIColor.redColor()]
        var attrString = NSMutableAttributedString()
        attrString = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(title![0]):"))
        if title?.count >= 2{
            let attrStar = NSMutableAttributedString(string: title![1], attributes: star)
            attrString.appendAttributedString(attrStar)
        }
        
        self.floatLabeledTextField.attributedPlaceholder = attrString
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
        return 55
    }
    
    
    
    
    //Mark: UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.Date , selectedDate: selectDate, target: self, action: "datePicked:element:", origin: textField)
        
        let str = self.rowDescriptor?.tag?.componentsSeparatedByString("(")
        
        if str![0] == "Expiration Date"{
            datePicker.minimumDate = NSDate()
        }else{
            datePicker.maximumDate = NSDate()
        }
        
        
        datePicker.showActionSheetPicker()
    
        return false
    }
        
    //MARK: Helpers
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
