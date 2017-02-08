//
//  AnalyticsManager.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 3/3/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics

class AnalyticsManager: NSObject {
    static let sharedInstance = AnalyticsManager()
    
    func logScreen(_ screenName:String){
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.allowIDFACollection = true
        tracker.set(kGAIScreenName, value: "home")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    func logEvent(_ tagCategory:String, tagEvent:String, tagLabel:String, tagValue:String){
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIEventCategory, value:tagCategory)
        tracker?.set(kGAIEventAction, value:tagEvent)
        tracker?.set(kGAIEventLabel, value:tagLabel)
        tracker?.set(kGAIEventValue, value:tagValue)
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker?.send(builder.build() as [NSObject : AnyObject])
        
    }
}
