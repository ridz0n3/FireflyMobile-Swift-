//
//  RSDFCustomDatePickerCollectionViewLayout.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/3/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import RSDayFlow

class RSDFCustomDatePickerCollectionViewLayout: RSDFDatePickerCollectionViewLayout {

    override func selfHeaderReferenceSize() -> CGSize {
        return CGSize.init(width: super.selfHeaderReferenceSize().width, height: 60)
    }
    
    override func selfItemSize() -> CGSize {
        return CGSize.init(width: super.selfItemSize().width, height: 60)
    }
    
}
