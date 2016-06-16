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
    case Loading(String, String, String, String, String, String, String, String, String, String)
    case ForgotPassword(String, String)
    case ChangePassword(String, String, String)
    case PassengerDetail(AnyObject, AnyObject, String, String, String, String)
    case ContactDetail(String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, AnyObject, AnyObject, String)
    case SelectSeat(AnyObject, AnyObject, String, String)
    case PaymentSelection(String)
    case PaymentProcess(String, String, String, String, String, String, String, String, String, String)
    case SearchFlight(Int, String, String, String, String, String, String, String, String)
    case SelectFlight(String, String, String, Int, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case FlightSummary(String)
    case Logout(String)
    case RetrieveBooking(String, String, String, String, String)
    case RetrieveBookingList(String, String, String, String)
    case ChangeContact(String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case EditPassengerDetail(AnyObject, AnyObject, String, String, String)
    case ConfirmChange(String, String, String)
    case GetAvailableSeat(String, String, String)
    case ChangeSeat(AnyObject, AnyObject, String, String, String)
    case SendItinerary(String, String, String)
    case GetFlightAvailability(String, String, String)
    case SearchChangeFlight(AnyObject, AnyObject, String, String, String)
    case SelectChangeFlight(String, String, String, Int, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case CheckIn(String, String, String, String, String)
    case GetTerm
    case CheckInPassengerList(String, String, String, String, AnyObject)
    case CheckInConfirmation(String, String, String, String, AnyObject)
    case RetrieveBoardingPass(String, String, String, String, String)
    case GetAbout
    case UpdateUserProfile(String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case RegisterUser(String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String)
    case RetrieveSSRList(String)
    case ChangeSSR(String, String, String, String, AnyObject)
    case ChangeSSR2Way(String, String, String, AnyObject, AnyObject)
    case EditFamilyAndFriend(String, String, String, String, String, String, String, String, String, Int)
    case AddFamilyAndFriend(String, String, String, String, String, String, String, String, String)
    case DeleteFamilyAndFriend(Int, String)
}



extension FireFlyAPI : TargetType {
    
    
    public var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        default:
            return .JSON
        }
    }
    
    var base: String {
        //return kStageURL
        return kDevURL//khttpsProductionURL
    }
    
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
        case ChangePassword:
            return "api/changePassword"
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
        case CheckIn:
            return "api/checkIn"
        case CheckInPassengerList:
            return "api/checkInPassengerList"
        case CheckInConfirmation:
            return "api/checkInConfirmation"
        case RetrieveBoardingPass:
            return "api/getBoardingPass"
        case GetAbout:
            return "api/getAboutUS"
        case .UpdateUserProfile:
            return "api/updateProfile"
        case .RegisterUser:
            return "api/register"
        case .RetrieveSSRList:
            return "api/getMealSSR"
        case .ChangeSSR:
            return "api/changeSSR"
        case .ChangeSSR2Way:
            return "api/changeSSR"
        case .EditFamilyAndFriend:
            return "api/editFamilyFriends"
        case .AddFamilyAndFriend:
            return "api/editFamilyFriends"
        case .DeleteFamilyAndFriend:
            return "api/deleteFamilyFriends"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .Login, .Loading, .ForgotPassword, .ChangePassword, .PassengerDetail, .ContactDetail, .SelectSeat, .PaymentSelection, .PaymentProcess, .SearchFlight, .SelectFlight, .FlightSummary, .Logout, .RetrieveBooking, .RetrieveBookingList, .ChangeContact, .EditPassengerDetail, .ConfirmChange, .GetAvailableSeat, .ChangeSeat, .SendItinerary, .GetFlightAvailability, .SearchChangeFlight, .SelectChangeFlight, .CheckIn, .CheckInPassengerList, .CheckInConfirmation, .RetrieveBoardingPass, .UpdateUserProfile, .RegisterUser, .RetrieveSSRList, .ChangeSSR, .ChangeSSR2Way, .EditFamilyAndFriend, .DeleteFamilyAndFriend, .AddFamilyAndFriend:
            return .POST
        case .GetTerm, .GetAbout:
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject]? {
        switch self {
        case .Login(let username, let password):
            return ["username": username, "password" : password]
        case .Loading(let signature, let username, let password, let sdkVersion, let version, let deviceId, let brand, let model, let dataVersion, let gcmKey):
            return ["signature" : signature, "username" : username, "password" : password, "sdkVersion": sdkVersion, "version" : version, "deviceId" : deviceId, "brand" : brand, "model" : model, "dataVersion" : dataVersion, "GCMKey" : gcmKey]
        case .ForgotPassword(let username, let signature):
            return ["username" : username, "signature" : signature]
        case .ChangePassword(let username, let password, let newPassword):
            return ["username" : username, "password" : password, "new_password" : newPassword]
        case .PassengerDetail(let adult, let infant, let bookId, let signature, let flightType, let email):
            return ["passengers" : adult, "infants" : infant, "booking_id" : bookId, "signature" : signature, "flight_type" : flightType, "user_email" : email]
        case .ContactDetail(let flightType, let bookId, let insurance, let purpose, let title, let firstName, let lastName, let email, let country, let mobile, let alternate, let signature, let companyName, let address1, let address2, let address3, let city, let state, let postcode, let seatStatus, let goingFlight, let returnFlight, let customer_number):
            return ["flight_type" : flightType, "booking_id" : bookId, "insurance" : insurance, "contact_travel_purpose" : purpose, "contact_title" : title, "contact_first_name" : firstName, "contact_last_name": lastName, "contact_email" : email, "contact_country" : country, "contact_mobile_phone" : mobile, "contact_alternate_phone" : alternate, "signature" : signature, "contact_company_name" : companyName, "contact_address1" : address1, "contact_address2": address2, "contact_address3" : address3, "contact_city" : city, "contact_state" : state, "contact_postcode" : postcode, "seat_selection_status" : seatStatus, "going_flight" : goingFlight, "return_flight" : returnFlight, "customer_number" : customer_number]
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
        case .RetrieveBooking(let signature, let pnr, let email, let userId, let customer_number):
            return ["signature" : signature, "pnr" : pnr, "username" : email, "user_id" : userId, "customer_number" : customer_number]
        case .RetrieveBookingList(let email, let password, let module, let customer_number):
            return ["username" : email, "password" : password, "module" : module, "customer_number" : customer_number]
        case .ChangeContact(let bookId, let insurance, let purpose, let title, let firstName, let lastName, let email, let country, let mobile, let alternate, let signature, let companyName, let address1, let address2, let address3, let city, let state, let postcode, let pnr, let customer_number):
            return ["booking_id" : bookId, "insurance" : insurance, "contact_travel_purpose" : purpose, "contact_title" : title, "contact_first_name" : firstName, "contact_last_name": lastName, "contact_email" : email, "contact_country" : country, "contact_mobile_phone" : mobile, "contact_alternate_phone" : alternate, "signature" : signature, "contact_company_name" : companyName, "contact_address1" : address1, "contact_address2": address2, "contact_address3" : address3, "contact_city" : city, "contact_state" : state, "contact_postcode" : postcode, "pnr" : pnr, "customer_number" : customer_number]
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
        case .CheckIn(let signature, let pnr, let userId, let departureCode, let arrivalCode):
            return ["signature" : signature, "pnr" : pnr, "user_id" : userId, "departure_station_code" : departureCode, "arrival_station_code" : arrivalCode]
            
        case .CheckInPassengerList(let pnr, let departure_station_code, let arrival_station_code, let signature, let passengers):
            return [
                "pnr" : pnr,
                "departure_station_code" : departure_station_code,
                "arrival_station_code" : arrival_station_code,
                "signature" : signature,
                "passengers" : passengers
            ]
        case .CheckInConfirmation(let pnr, let departure_station_code, let arrival_station_code, let signature, let passengers):
            return [
                "pnr" : pnr,
                "departure_station_code" : departure_station_code,
                "arrival_station_code" : arrival_station_code,
                "signature" : signature,
                "passengers" : passengers
            ]
        case .RetrieveBoardingPass(let signature, let pnr, let departureCode, let arrivalCode, let userId):
            return ["signature" : signature, "pnr" : pnr, "departure_station_code" : departureCode, "arrival_station_code" : arrivalCode, "user_id" : userId]
        case .UpdateUserProfile(let username, let password, let new_password, let title, let first_name, let last_name, let dob, let address_1, let address_2, let address_3, let country, let city, let state, let postcode, let mobile_phone, let alternate_phone, let fax, let bonuslink, let signature, let newsletter) :
            return ["username" : username, "password" : password, "new_password" : new_password, "title" : title, "first_name" : first_name, "last_name" : last_name, "dob" : dob, "address_1" : address_1, "address_2" : address_2, "address_3" : address_3, "country" : country, "city" : city, "state" : state, "postcode" : postcode, "mobile_phone" : mobile_phone, "alternate_phone" : alternate_phone, "fax" : fax, "bonuslink" : bonuslink, "signature" : signature, "newsletter" : newsletter]
        case .RegisterUser(let username, let password, let title, let first_name, let last_name, let dob, let address_1, let address_2, let address_3, let country, let city, let state, let postcode, let mobile_phone, let alternate_phone, let fax, let bonuslink, let signature, let newsletter) :
            return ["username" : username, "password" : password, "title" : title, "first_name" : first_name, "last_name" : last_name, "dob" : dob, "address_1" : address_1, "address_2" : address_2, "address_3" : address_3, "country" : country, "city" : city, "state" : state, "postcode" : postcode, "mobile_phone" : mobile_phone, "alternate_phone" : alternate_phone, "fax" : fax, "bonuslink" : bonuslink, "signature" : signature, "newsletter" : newsletter]
        case .RetrieveSSRList(let signature) :
            return ["signature" : signature]
        case .ChangeSSR(let pnr, let booking_id, let signature, let type, let detailSSR) :
            return ["pnr" : pnr, "booking_id" : booking_id, "signature" : signature, type : detailSSR]
        case .ChangeSSR2Way(let pnr, let booking_id, let signature, let goingSSR, let returnSSR) :
            return ["pnr" : pnr, "booking_id" : booking_id, "signature" : signature, "going_flight" : goingSSR, "return_flight" : returnSSR]
        case .EditFamilyAndFriend(let email, let title, let gender, let firstName, let lastName, let dob, let country, let type, let bonuslink, let familyId) :
            return ["bonuslink": bonuslink,
                    "dob":dob,
                    "first_name":firstName,
                    "friend_and_family_id":familyId,
                    "issuing_country":country,
                    "last_name":lastName,
                    "passenger_type":type,
                    "title":title,
                    "gender":gender,
                    "user_email":email]
        case .DeleteFamilyAndFriend(let id, let email):
            return ["deleteID" : id, "user_email" : email]
        case .AddFamilyAndFriend(let email, let title, let gender, let firstName, let lastName, let dob, let country, let type, let bonuslink) :
            return ["bonuslink": bonuslink,
                    "dob":dob,
                    "first_name":firstName,
                    "issuing_country":country,
                    "last_name":lastName,
                    "passenger_type":type,
                    "title":title,
                    "gender":gender,
                    "user_email":email]
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


var endpointClosure = { (target: FireFlyAPI, method: Moya.Method, parameters: [String: AnyObject]) -> Endpoint<FireFlyAPI> in
    return Endpoint(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: target.parameterEncoding)
}
