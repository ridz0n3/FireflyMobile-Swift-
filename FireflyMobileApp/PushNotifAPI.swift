//
//  PushNotifAPI.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 5/5/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import Foundation
import Moya

let PushNotifProvider = MoyaProvider<PushNotifAPI>(endpointClosure: {
    (target: PushNotifAPI) -> Endpoint<PushNotifAPI> in
    
    return Endpoint(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
})

// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public enum PushNotifAPI{
    case ListUser
    case RegisterUser(String)
    case UpdateToken(String, String)
}

extension PushNotifAPI : TargetType{
    
    public var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        default:
            return .JSON
        }
    }
    
    var base: String {
        //return kStageURL
        return "http://192.168.0.119/pushnotification/public"
    }
    
    public var baseURL: NSURL { return NSURL(string: base)! }
    
    public var path: String {
        switch self {
        case ListUser:
            return "/Register"
        case RegisterUser:
            return "/Register"
        case UpdateToken:
            return "api/getTerm"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .RegisterUser, .UpdateToken:
            return .POST
        case .ListUser:
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject]? {
        switch self {
        case .RegisterUser(let device_name):
            return ["device_name" : device_name]
        case .UpdateToken(let id, let gcm_token):
            return ["id" : id, "gcm_token" : gcm_token]
        default:
            return nil
        }
    }
    
    public var sampleData: NSData {
        return NSData.init()
    }
}

/*var endpointClosure = { (target: PushNotifAPI, method: Moya.Method, parameters: [String: AnyObject]) -> Endpoint<PushNotifAPI> in
    return Endpoint(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
}*/
