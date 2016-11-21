//
//  RSDFCustomDatePickerDaysOfWeekView.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/3/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import RSDayFlow

class RSDFCustomDatePickerDaysOfWeekView: RSDFDatePickerDaysOfWeekView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func selfBackgroundColor() -> UIColor {
        return UIColor(red: 244/255, green: 245/255, blue: 247/255, alpha: 1.0)
    }
    
    override func dayOffOfWeekLabelTextColor() -> UIColor {
        return UIColor.black
    }

}
