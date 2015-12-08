//
//  FireFlyAPI.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 11/23/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import Foundation
import Moya

let FireFlyProvider = MoyaProvider<FireFlyAPI>()

// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public enum FireFlyAPI {
    case Login(String, String)
    case Loading(String, String, String, String, String, String, String, String, String)
    case ForgotPassword(String, String)
    
}


extension FireFlyAPI : TargetType {
    
    /*   var base: String { return AppSetup.sharedState.useStaging ? "https://stagingapi.artsy.net" : "https://api.artsy.net" } */
    var base: String {return "http://fyapidev.me-tech.com.my/"}
    
    public var baseURL: NSURL { return NSURL(string: base)! }
    
    public var path: String {
        switch self {
        case Login:
            return "api/login"
        case Loading:
            return "api/loading"
        case ForgotPassword:
            return "api/forgotPassword"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .Login, .Loading , .ForgotPassword:
            return .POST
            
        default:
            return .GET
        }
    }
    public var parameters: [String: AnyObject]? {
        switch self {
        case .Login(let username, let password):
            return ["username": username, "password" : password]
        case .Loading(let signature, let username, let password, let sdkVersion, let version, let deviceId, let brand, let model, let dataVersion):
            return ["signature" : signature, "username" : username, "password" : password, "sdkVersion": sdkVersion, "version" : version, "deviceId" : deviceId, "brand" : brand, "model" : model, "dataVersion" : dataVersion]
        case .ForgotPassword(let username, let signature):
            return ["username" : username, "signature" : signature]
        default:
            return nil
        }
    }
    public var sampleData: NSData {
        return NSData.init()
    }
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

let endpointClosure = { (target: FireFlyAPI, method: Moya.Method, parameters: [String: AnyObject]) -> Endpoint<FireFlyAPI> in
    return Endpoint<FireFlyAPI>(URL: url(target),  sampleResponseClosure: {.NetworkResponse(200, target.sampleData)},method: method, parameters: parameters)
}
