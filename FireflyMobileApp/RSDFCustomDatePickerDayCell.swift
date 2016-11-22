//
//  RSDFCustomDatePickerDayCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/3/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import RSDayFlow

class RSDFCustomDatePickerDayCell: RSDFDatePickerDayCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func dayLabelFont() -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: 16.0)
    }
    
    override func dayLabelTextColor() -> UIColor {
        return UIColor(red: 51/255, green: 37/255, blue: 37/255, alpha: 1.0)
    }
    
    override func selectedDayImageColor() -> UIColor {
        return UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
    }
    
    override func selectedDayLabelFont() -> UIFont {
        return dayLabelFont()
    }
    
    override func selectedDayLabelTextColor() -> UIColor {
        return dayLabelTextColor()
    }
    
    override func dayOffLabelTextColor() -> UIColor {
        return UIColor(red: 51/255, green: 37/255, blue: 36/255, alpha: 1.0)
    }
    
    override func todayLabelFont() -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: 17.0)
    }
    
    override func todayLabelTextColor() -> UIColor {
        return UIColor(red: 3/255, green: 117/255, blue: 214/255, alpha: 1.0)
    }
    
    override func selectedTodayImageColor() -> UIColor {
        return UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
    }
    
    override func selectedTodayLabelFont() -> UIFont {
        return todayLabelFont()
    }
    
    override func selectedTodayLabelTextColor() -> UIColor {
        return todayLabelTextColor()
    }
    
    override func overlayImageColor() -> UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    override func dividerImageColor() -> UIColor {
        return UIColor.clearColor()
    }
    
    override func pastDayLabelTextColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    override func pastDayOffLabelTextColor() -> UIColor {
        return UIColor.lightGrayColor()
    }

}
