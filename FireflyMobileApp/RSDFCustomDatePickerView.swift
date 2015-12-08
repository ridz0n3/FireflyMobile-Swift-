//
//  RSDFCustomDatePickerView.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/3/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import RSDayFlow

class RSDFCustomDatePickerView: RSDFDatePickerView {

    override func daysOfWeekViewClass() -> AnyClass! {
        return RSDFDatePickerDaysOfWeekView.classForCoder()
    }
    
    override func collectionViewClass() -> AnyClass! {
        return RSDFCustomDatePickerCollectionView.classForCoder()
    }
    
    override func collectionViewLayoutClass() -> AnyClass! {
        return RSDFCustomDatePickerCollectionViewLayout.classForCoder()
    }
    
    override func monthHeaderClass() -> AnyClass! {
        return RSDFCustomDatePickerMonthHeader.classForCoder()
    }
    
    override func dayCellClass() -> AnyClass! {
        return RSDFCustomDatePickerDayCell.classForCoder()
    }

}
