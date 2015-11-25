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
    case ResetPassword(String)
}

extension FireFlyAPI : MoyaTarget {

 /*   var base: String { return AppSetup.sharedState.useStaging ? "https://stagingapi.artsy.net" : "https://api.artsy.net" } */
    var base: String {return "http://fyapidev.me-tech.com.my/"}
   
    public var baseURL: NSURL { return NSURL(string: base)! }

    public var path: String {
        switch self {
        case Login:
            return "api/Login"
        
        case ResetPassword:
            return ""
        }
    }
    public var method: Moya.Method {
        switch self {
        case .Login, .ResetPassword :
            return .POST
            
        default:
        return .GET
    }
    }
    public var parameters: [String: AnyObject]? {
        switch self {
        case Login(let username, let password):
            return ["username": username, "password" : password]
    default:
        return nil
    }
    }
     public var sampleData: NSData {
        switch self {
        case Login(let username, let password):
            return "{\"username\": \"\(username)\", \"password\":\"\(password)}".dataUsingEncoding(NSUTF8StringEncoding)!
        case ResetPassword(let id):
            return "{\"login\": \"\(id)\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

public func url(route: MoyaTarget) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

let endpointClosure = { (target: FireFlyAPI, method: Moya.Method, parameters: [String: AnyObject]) -> Endpoint<FireFlyAPI> in
      return Endpoint<FireFlyAPI>(URL: url(target),  sampleResponseClosure: {.NetworkResponse(200, target.sampleData)},method: method, parameters: parameters)
}
