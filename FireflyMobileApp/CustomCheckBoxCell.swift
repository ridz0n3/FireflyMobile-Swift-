//
//  CustomCheckBoxCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/9/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import M13Checkbox

let XLFormRowDescriptorCheckbox = "XLFormRowDescriptorTypeCheckbox"

class CustomCheckBoxCell: XLFormBaseCell {

    enum kSave: Int {
        case
        status = 1
        
        func description() -> String {
            switch self {
            case .status:
                return "status"
            }
        }
        
        //Add Custom Functions
        
        //Allows for iteration as needed (for in ...)
        static let allValues = [status]
    }
    
    @IBOutlet weak var checkButtonButton: UIButton!
    @IBOutlet weak var familySelect: M13Checkbox!
    @IBOutlet weak var titleLbl: UILabel!
    
    //MARK: - XLFormDescriptorCell
    
    override func configure() {
        super.configure()
        familySelect.strokeColor = UIColor.orangeColor()
        familySelect.checkColor = UIColor.orangeColor()
    }
    
    override func update() {
        super.update()
        titleLbl.text = rowDescriptor.title
        updateButtons()
    }
    
    override static func formDescriptorCellHeightForRowDescriptor(rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 40
    }
    
    //MARK: - Action
    
    @IBAction func dayTapped(sender: UIButton) {
        let checked = getCheckFormButton(sender)
        sender.selected = !sender.selected
        var newValue = rowDescriptor!.value as! Dictionary<String, Bool>
        newValue[checked] = sender.selected
        rowDescriptor!.value = newValue
        
        if newValue[checked] == false{
            familySelect.checkState = .Unchecked
        }else{
            familySelect.checkState = .Checked
        }
    }
    
    //MARK: - Helpers
    
    func updateButtons() {
        var value = rowDescriptor!.value as! Dictionary<String, Bool>
        
        if value[kSave.status.description()]! == false{
            familySelect.checkState = .Unchecked
        }else{
            familySelect.checkState = .Checked
        }
        
        checkButtonButton.selected = value[kSave.status.description()]!
        checkButtonButton.alpha = rowDescriptor!.isDisabled() ? 0.6 : 1
    }
    
    func getCheckFormButton(button: UIButton) -> String {
        switch button {
        case checkButtonButton:
            return kSave.status.description()
        default:
            return kSave.status.description()
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
