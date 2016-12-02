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
        
        //FIRAnalytics.setScreenName(screenName, screenClass: )
       /* let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: screenName)
        
        let builder = _DictionaryBuilder.createScreenView()
        //tracker!.send((builder?.build())! as NSMutableDictionary)*/
    
    }
    
    func logEvent(_ tagCategory:String, tagEvent:String, tagLabel:String, tagValue:String){
       /* let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIEventCategory, value:tagCategory)
        tracker?.set(kGAIEventAction, value:tagEvent)
        tracker?.set(kGAIEventLabel, value:tagLabel)
        tracker?.set(kGAIEventValue, value:tagValue)
        let builder = GAIDictionaryBuilder.createScreenView()
        //tracker?.send(builder?.build() as [NSObject : AnyObject])
        */
    }
}
