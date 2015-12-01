//
//  NetworkManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 11/26/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import Foundation
import Moya
import ReactiveCocoa

/// Request to fetch a given target. Ensures that valid XApp tokens exist before making request
/*func XAppRequest(provider: FireFlyProvider<FireFlyAPI> = Provider.sharedProvider, defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()) -> RACSignal {
    
    return provider.onlineSignal.ignore(false).take(1).then {
        // First perform XAppTokenRequest(). When it completes, then the signal returned from the closure will be subscribed to.
        XAppTokenRequest(defaults).then {
            return provider.request(token)
        }
    }
}*/