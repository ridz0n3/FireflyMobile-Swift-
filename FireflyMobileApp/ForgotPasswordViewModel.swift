//
//  ForgotPasswordViewModel.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 11/25/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import Foundation
import Moya
import ReactiveCocoa

class ForgotPasswordViewModel: NSObject {

    let email: String
    
    init(passwordSignal: RACSignal, manualInvocationSignal: RACSignal, finishedSubject: RACSubject, email: String){
        self.email = email
    }
    func userForgotPasswordSignal() -> RACSignal {
        let endpoint: FireFlyAPI = FireFlyAPI.ResetPassword(email)
        return Provider.sharedProvider.request(endpoint)
    }
}
