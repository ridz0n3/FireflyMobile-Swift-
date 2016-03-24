//  FloatLabeledTextFieldCell.swift
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014-2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import XLForm
import JVFloatLabeledTextField

let XLFormRowDescriptorTypeFloatLabeledTextField = "XLFormRowDescriptorTypeFloatLabeledTextField"

extension XLFormBaseCell: UITextFieldDelegate{
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.blueColor()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPressed")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        self.endEditing(true)
    }
    func cancelPressed(){
        self.endEditing(true) // or do something
    }
}

class FloatLabeledTextFieldCell : XLFormBaseCell {
    
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
        
        //addToolBar(self.floatLabeledTextField)
        contentView.addConstraints(layoutConstraints())
    }
    
    override func update() {
        super.update()
        if self.rowDescriptor?.tag == "Password" || self.rowDescriptor?.tag == "New Password" || self.rowDescriptor?.tag == "Confirm Password"{
            self.floatLabeledTextField.keyboardType = .ASCIICapable
            self.floatLabeledTextField.secureTextEntry = true
        }else if self.rowDescriptor?.tag == "Mobile/Home" || self.rowDescriptor?.tag == "Alternate" || self.rowDescriptor?.tag == "Postcode" || self.rowDescriptor?.tag == "CCV/CVC Number" || self.rowDescriptor?.tag == "Card Number" || self.rowDescriptor?.tag == "Bonuslink"{
            self.floatLabeledTextField.keyboardType = .PhonePad
        }
        
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
    
    //Mark: UITextFieldDelegate
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return self.formViewController().textFieldShouldClear(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true //self.formViewController().textFieldShouldReturn(textField)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return true//self.formViewController().textFieldShouldBeginEditing(textField)
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
    
}
