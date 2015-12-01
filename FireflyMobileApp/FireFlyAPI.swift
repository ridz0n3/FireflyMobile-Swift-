//
//  FireFlyAPI.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 11/23/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import Foundation
import Moya
import ReactiveCocoa
import Alamofire

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

func endpointResolver() -> MoyaProvider<FireFlyAPI>.RequestClosure {
    return { (endpoint, closure) in
        let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
        request.HTTPShouldHandleCookies = false
        closure(request)
    }
}
public func url(route: MoyaTarget) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

let endpointClosure = { (target: FireFlyAPI, method: Moya.Method, parameters: [String: AnyObject]) -> Endpoint<FireFlyAPI> in
      return Endpoint<FireFlyAPI>(URL: url(target),  sampleResponseClosure: {.NetworkResponse(200, target.sampleData)},method: method, parameters: parameters)
}

class FireFlyProvider<Target where Target: MoyaTarget>: ReactiveCocoaMoyaProvider<Target>{
     let onlineSignal: RACSignal

    init(endpointClosure: MoyaProvider<Target>.EndpointClosure = MoyaProvider.DefaultEndpointMapping,
        requestClosure: MoyaProvider<Target>.RequestClosure = MoyaProvider.DefaultRequestMapping,
        stubClosure: MoyaProvider<Target>.StubClosure = MoyaProvider.NeverStub,
        manager: Manager = Alamofire.Manager.sharedInstance,
        plugins: [Plugin<Target>] = [],
        onlineSignal: RACSignal = connectedToInternetOrStubbingSignal()) {

            self.onlineSignal = onlineSignal
            super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
    }

}

struct Provider {
    
    private struct SharedProvider {
        static var instance = Provider.DefaultProvider()
    }
    
    static var sharedProvider: FireFlyProvider<FireFlyAPI> {
        get {
            return SharedProvider.instance
        }
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
    }
    
    private static var endpointsClosure = { (target: FireFlyAPI) -> Endpoint<FireFlyAPI> in
        var endpoint: Endpoint<FireFlyAPI> = Endpoint<FireFlyAPI>(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        return endpoint
    }
    
    static func DefaultProvider() -> FireFlyProvider<FireFlyAPI> {
        return FireFlyProvider(endpointClosure: endpointsClosure,
            requestClosure: endpointResolver())
    }
}
