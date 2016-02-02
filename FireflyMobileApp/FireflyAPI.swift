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
    case PaymentSelection(String)
    case PaymentProcess(String, String, String, String, String, String, String, String, String, String)
    case SearchFlight(Int, String, String, String, String, String, String, String, String)
    case SelectFlight(String, String, String, Int, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case FlightSummary(String)
    case Logout(String)
    case RetrieveBooking(String, String, String, String)
    case RetrieveBookingList(String, String, String)
    case ChangeContact(String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case EditPassengerDetail(AnyObject, AnyObject, String, String, String)
    case ConfirmChange(String, String, String)
    case GetAvailableSeat(String, String, String)
    case ChangeSeat(AnyObject, AnyObject, String, String, String)
    case SendItinerary(String, String, String)
    case GetFlightAvailability(String, String, String)
    case SearchChangeFlight(AnyObject, AnyObject, String, String, String)
    case SelectChangeFlight(String, String, String, Int, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case GetTerm
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
        case GetTerm:
            return "api/getTerm"
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
        case PaymentSelection:
            return "api/selectionPayment"
        case PaymentProcess:
            return "api/paymentProcess"
        case SearchFlight:
            return "api/searchFlight"
        case SelectFlight:
            return "api/selectFlight"
        case FlightSummary:
            return "api/flightSummary"
        case Logout:
            return "api/logout"
        case RetrieveBooking:
            return "api/retrieveBooking"
        case RetrieveBookingList:
            return "api/retrieveBookingList"
        case ChangeContact:
            return "api/changeContact"
        case EditPassengerDetail:
            return "api/editPassengers"
        case ConfirmChange:
            return "api/changeConfirmation"
        case GetAvailableSeat:
            return "api/getSeatAvailability"
        case ChangeSeat:
            return "api/changeSeat"
        case SendItinerary:
            return "api/sendItinerary"
        case GetFlightAvailability:
            return "api/getFlightAvailability"
        case SearchChangeFlight:
            return "api/searchChangeFlight"
        case SelectChangeFlight:
            return "api/selectChangeFlight"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .Login, .Loading, .ForgotPassword, .PassengerDetail, .ContactDetail, .SelectSeat, .PaymentSelection, .PaymentProcess, .SearchFlight, .SelectFlight, .FlightSummary, .Logout, .RetrieveBooking, .RetrieveBookingList, .ChangeContact, .EditPassengerDetail, .ConfirmChange, .GetAvailableSeat, .ChangeSeat, .SendItinerary, .GetFlightAvailability, .SearchChangeFlight, .SelectChangeFlight:
            return .POST
        case .GetTerm:
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
        case PaymentSelection(let signature):
            return ["signature" : signature]
        case PaymentProcess(let signature, let channelType, let channelCode, let cardNumber, let expirationDateMonth, let expirationDateYear, let cardHolderName, let issuingBank, let cvv, let booking_id):
            return ["signature" : signature, "channelType" : channelType, "channelCode" : channelCode, "cardNumber": cardNumber, "expirationDateMonth" : expirationDateMonth, "expirationDateYear" : expirationDateYear, "cardHolderName" : cardHolderName, "issuingBank" : issuingBank, "cvv" : cvv, "bookingId" : booking_id]
        case .SearchFlight(let type, let departure_station, let arrival_station, let departure_date, let return_date, let adult, let infant, let username, let password):
            return ["type" : type, "departure_station" : departure_station, "arrival_station" : arrival_station, "departure_date": departure_date, "return_date" : return_date, "adult" : adult, "infant" : infant, "username" : username, "password" : password]
        case .SelectFlight(let adult, let infant, let username, let type, let departure_date, let arrival_time_1, let departure_time_1, let fare_sell_key_1, let flight_number_1, let journey_sel_key_1, let return_date, let arrival_time_2, let departure_time_2, let fare_sell_key_2, let flight_number_2, let journey_sel_key_2, let departure_station, let arrival_station):
            return [
                "adult" : adult,
                "infant" : infant,
                "username" : username,
                "type" : type,
                "departure_date" : departure_date,
                "arrival_time_1" : arrival_time_1,
                "departure_time_1" : departure_time_1,
                "fare_sell_key_1" : fare_sell_key_1,
                "flight_number_1" : flight_number_1,
                "journey_sell_key_1" : journey_sel_key_1,
                "return_date" : return_date,
                "arrival_time_2" : arrival_time_2,
                "departure_time_2" : departure_time_2,
                "fare_sell_key_2" : fare_sell_key_2,
                "flight_number_2" : flight_number_2,
                "journey_sell_key_2" : journey_sel_key_2,
                "departure_station" : departure_station,
                "arrival_station" : arrival_station
            ]
        case .FlightSummary(let signature):
            return ["signature" : signature]
        case .Logout(let signature):
            return ["signature" : signature]
        case .RetrieveBooking(let signature, let pnr, let email, let userId):
            return ["signature" : signature, "pnr" : pnr, "username" : email, "user_id" : userId]
        case .RetrieveBookingList(let email, let password, let module):
            return ["username" : email, "password" : password, "module" : module]
        case .ChangeContact(let bookId, let insurance, let purpose, let title, let firstName, let lastName, let email, let country, let mobile, let alternate, let signature, let companyName, let address1, let address2, let address3, let city, let state, let postcode, let pnr):
            return ["booking_id" : bookId, "insurance" : insurance, "contact_travel_purpose" : purpose, "contact_title" : title, "contact_first_name" : firstName, "contact_last_name": lastName, "contact_email" : email, "contact_country" : country, "contact_mobile_phone" : mobile, "contact_alternate_phone" : alternate, "signature" : signature, "contact_company_name" : companyName, "contact_address1" : address1, "contact_address2": address2, "contact_address3" : address3, "contact_city" : city, "contact_state" : state, "contact_postcode" : postcode, "pnr" : pnr]
        case .EditPassengerDetail(let adult, let infant, let bookId, let signature, let pnr):
            return ["passengers" : adult, "infants" : infant, "booking_id" : bookId, "signature" : signature, "pnr" : pnr]
        case .ConfirmChange(let pnr, let booking_id, let signature):
            return ["pnr" : pnr, "booking_id" : booking_id, "signature" : signature]
        case .GetAvailableSeat(let pnr, let booking_id, let signature):
            return ["pnr" : pnr, "booking_id" : booking_id, "signature" : signature]
        case .ChangeSeat(let goingFlight, let returnFlight, let bookId, let signature, let pnr):
            return ["going_flight" : goingFlight, "return_flight" : returnFlight, "booking_id" : bookId, "signature" : signature, "pnr" : pnr]
        case .SendItinerary(let pnr, let booking_id, let signature):
            return ["pnr" : pnr, "booking_id" : booking_id, "signature" : signature]
        case .GetFlightAvailability(let pnr, let booking_id, let signature):
            return ["pnr" : pnr, "booking_id" : booking_id, "signature" : signature]
        case .SearchChangeFlight(let departure, let returned, let pnr, let booking_id, let signature):
            return ["going_flight" : departure, "return_flight" : returned, "pnr" : pnr, "booking_id" : booking_id, "signature" : signature]
        case .SelectChangeFlight(let pnr, let booking_id, let signature, let type, let departure_date, let arrival_time_1, let departure_time_1, let fare_sell_key_1, let flight_number_1, let journey_sel_key_1, let status_1, let return_date, let arrival_time_2, let departure_time_2, let fare_sell_key_2, let flight_number_2, let journey_sel_key_2, let status_2, let departure_station, let arrival_station):
            return [
                "pnr" : pnr,
                "booking_id" : booking_id,
                "signature" : signature,
                "type" : type,
                "departure_date" : departure_date,
                "arrival_time_1" : arrival_time_1,
                "departure_time_1" : departure_time_1,
                "fare_sell_key_1" : fare_sell_key_1,
                "flight_number_1" : flight_number_1,
                "journey_sell_key_1" : journey_sel_key_1,
                "status_1" : status_1,
                "return_date" : return_date,
                "arrival_time_2" : arrival_time_2,
                "departure_time_2" : departure_time_2,
                "fare_sell_key_2" : fare_sell_key_2,
                "flight_number_2" : flight_number_2,
                "journey_sell_key_2" : journey_sel_key_2,
                "status_2" : status_2,
                "departure_station" : departure_station,
                "arrival_station" : arrival_station
            ]
        
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
