//
//  GlobalFunctions.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 11/26/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import ReactiveCocoa
import Reachability
import Moya

private let reachabilityManager = ReachabilityManager()

func connectedToInternetOrStubbingSignal() -> RACSignal {    
    return reachabilityManager.reachSignal
}
private class ReachabilityManager: NSObject {

    let reachSignal: RACSignal = RACReplaySubject(capacity: 1)
    
    private let reachability = Reachability.reachabilityForInternetConnection()
    
    override init() {
        super.init()
        
        reachability.reachableBlock = { (_) in
            return (self.reachSignal as! RACSubject).sendNext(true)
        }
        
        reachability.unreachableBlock =  { (_) in
            return (self.reachSignal as! RACSubject).sendNext(false)
        }
        
        reachability.startNotifier()
        (reachSignal as! RACSubject).sendNext(reachability.isReachable())
    }
}
