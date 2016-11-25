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
        familySelect.strokeColor = UIColor.orange
        familySelect.checkColor = UIColor.orange
    }
    
    override func update() {
        super.update()
        titleLbl.text = rowDescriptor.title
        updateButtons()
    }
    
    override static func formDescriptorCellHeight(for rowDescriptor: XLFormRowDescriptor!) -> CGFloat {
        return 40
    }
    
    //MARK: - Action
    
    @IBAction func dayTapped(_ sender: UIButton) {
        let checked = getCheckFormButton(sender)
        sender.isSelected = !sender.isSelected
        var newValue = rowDescriptor!.value as! Dictionary<String, Bool>
        newValue[checked] = sender.isSelected
        rowDescriptor!.value = newValue
        
        if newValue[checked] == false{
            familySelect.checkState = .unchecked
        }else{
            familySelect.checkState = .checked
        }
    }
    
    //MARK: - Helpers
    
    func updateButtons() {
        var value = rowDescriptor!.value as! Dictionary<String, Bool>
        
        if value[kSave.status.description()]! == false{
            familySelect.checkState = .unchecked
        }else{
            familySelect.checkState = .checked
        }
        
        checkButtonButton.isSelected = value[kSave.status.description()]!
        checkButtonButton.alpha = rowDescriptor!.isDisabled() ? 0.6 : 1
    }
    
    func getCheckFormButton(_ button: UIButton) -> String {
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
