//
//  FireFlyAPI.swift
//  FireflyMobileApp
//
//  Created by ME-Tech MacPro User 2 on 11/23/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import Foundation
import Moya

let FireFlyProvider = MoyaProvider<FireFlyAPI>(endpointClosure: {
    (target: FireFlyAPI) -> Endpoint<FireFlyAPI> in
    
    return Endpoint(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
})

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
    case PassengerDetail(AnyObject, AnyObject, String, String)
    case ContactDetail(String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case SelectSeat(AnyObject, AnyObject, String, String)
    
}



extension FireFlyAPI : TargetType {
    
    
    public var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        default:
            return .JSON
        }
    }
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
        case PassengerDetail:
            return "api/passengerDetails"
        case ContactDetail:
            return "api/contactDetails"
        case SelectSeat:
            return "api/seatMap"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .Login, .Loading , .ForgotPassword, .PassengerDetail, .ContactDetail, .SelectSeat:
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
        case .PassengerDetail(let adult, let infant, let bookId, let signature):
            return ["passengers" : adult, "infants" : infant, "booking_id" : bookId, "signature" : signature]
        case .ContactDetail(let bookId, let insurance, let purpose, let title, let firstName, let lastName, let email, let country, let mobile, let alternate, let signature, let companyName, let address1, let address2, let address3, let city, let state, let postcode, let seatStatus):
            return ["booking_id" : bookId, "insurance" : insurance, "contact_travel_purpose" : purpose, "contact_title" : title, "contact_first_name" : firstName, "contact_last_name": lastName, "contact_email" : email, "contact_country" : country, "contact_mobile_phone" : mobile, "contact_alternate_phone" : alternate, "signature" : signature, "contact_company_name" : companyName, "contact_address1" : address1, "contact_address2": address2, "contact_address3" : address3, "contact_city" : city, "contact_state" : state, "contact_postcode" : postcode, "seat_selection_status" : seatStatus]
        case .SelectSeat(let goingFlight, let returnFlight, let bookId, let signature):
            return ["going_flight" : goingFlight, "return_flight" : returnFlight, "booking_id" : bookId, "signature" : signature]
            
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
    return Endpoint(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
}
