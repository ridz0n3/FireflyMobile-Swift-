//
//  Constant.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/20/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift

let realm = try! Realm()
let defaults = NSUserDefaults.standardUserDefaults()
let key = "owNLfnLjPvwbQH3hUmj5Wb7wBIv83pR7" // length == 3
let iv = "owNLfnLjPvwbQH3h" // length == 16
let kStageURL = "http://fyapistage.me-tech.com.my/"
let kProductionURL = "http://fyapi.me-tech.com.my/"//
let kDevURL = "http://fyapidev.me-tech.com.my/"
let khttpsProductionURL = "https://m.fireflyz.com.my/"
let estimote_uuid = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
let virtual_uuid = NSUUID(UUIDString: "8492E75F-4FD6-469D-B132-043FE94921D8")
var deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString

var purposeArray:[Dictionary<String,AnyObject>] = [["purpose_code":"1","purpose_name":"Leisure"],["purpose_code":"2","purpose_name":"Business"]]
var travelDoc : [Dictionary<String, AnyObject>] = [["doc_code":"P","doc_name":"Passport"],["doc_code":"NRIC","doc_name":"Malaysia IC"],["doc_code":"V","doc_name":"Travel VISA"]]
var genderArray : [Dictionary<String, AnyObject>] = [["gender_code":"Female","gender_name":"Female"],["gender_code":"Male","gender_name":"Male"]]
var titleArray = defaults.objectForKey("title") as! [Dictionary<String,AnyObject>]
var countryArray = defaults.objectForKey("country") as! [Dictionary<String,AnyObject>]

internal struct Tags {
    static let ValidationUsername = "Email"
    static let ValidationPassword = "Password"
    static let ValidationNewPassword = "New Password"
    static let ValidationConfirmPassword = "Confirm Password"
    static var ValidationTitle = "Title"
    static var ValidationFirstName = "First Name"
    static var ValidationLastName = "Last Name"
    static var ValidationDate = "Date"
    static let ValidationAddressLine1 = "Address Line 1"
    static let ValidationAddressLine2 = "Address Line 2"
    static let ValidationAddressLine3 = "Address Line 3"
    static var ValidationCountry = "Country"
    static let ValidationTownCity = "Town/City"
    static let ValidationState = "State"
    static let ValidationPostcode = "Postcode"
    static let ValidationMobileHome = "Mobile/Home"
    static let ValidationAlternate = "Alternate"
    static let ValidationFax = "Fax"
    static let ValidationEmail = "Email"
    static var ValidationTravelDoc = "Travel Document"
    static var ValidationDocumentNo = "Document No"
    static var ValidationExpiredDate = "Expiration Date"
    static var ValidationEnrichLoyaltyNo = "Bonuslink"
    static var ValidationTravelWith = "Traveling with"
    static var ValidationGender = "Gender"
    static var ValidationPurpose = "Purpose"
    static var ValidationCompanyName = "Company Name"
    static var ValidationCardType = "Card Type"
    static var ValidationCardNumber = "Card Number"
    static var ValidationCardExpiredDate = "Card Expiration Date"
    static var ValidationHolderName = "Holder Name"
    static var ValidationCcvNumber = "CCV/CVC Number"
    static var ValidationConfirmationNumber = "Confirmation Number"
    static var ValidationDeparting = "Departing"
    static var ValidationArriving = "Arriving"
    static var ValidationSSRList = "Meals"
    static var HideSection = "hide"
    
}

struct GAConstants {
    
    static let homeScreen = "Home";
    static let aboutUsScreen = "About Us";
    static let loginScreen = "Login";
    static let registerScreen = "Register";
    static let faqScreen = "FAQ";
    static let sideMenuScreen = "Side Menu";
    static let updateInformationScreen = "Update Information";
    static let searchFlightScreen = "Book Flight: Search Flight";
    static let flightDetailsScreen = "Book Flight: Flight Details";
    static let mhFlightDetailsScreen = "Book Flight: Flight Details(MH)";
    static let passengerDetailsScreen = "Book Flight: Personal Details(Passenger Details)";
    static let contactDetailsScreen = "Book Flight: Personal Details(Contact Details)";
    static let seatSelectionScreen = "Book Flight: Choose Seat";
    static let paymentSummaryScreen = "Book Flight: Payment Details(Payment Summary)";
    static let addPaymentScreen = "Book Flight: Payment Details(Add Payment)";
    static let paymentBookWebScreen = "Book Flight: Payment Details(Payment Web)";
    static let flightBookingSummaryScreen = "Book Flight: Flight Summary";
    static let loginManageFlightScreen = "Manage Flight: Login Manage Flight";
    static let manageFlightScreen = "Manage Flight: Manage Flight";
    static let manageFlightHomeScreen = "Manage Flight: Manage Flight Home";
    static let editContactDetailScreen = "Edit Contact Detail";
    static let editPassengerDetailScreen = "Edit Passenger Detail";
    static let editSearchFlightScreen = "Edit Search Flight";
    static let editFlightDetailScreen = "Edit Flight Detail";
    static let editMhFlightDetailScreen = "Edit MH Flight Detail";
    static let editSeatSelectionScreen = "Edit Seat Selection";
    static let editPaymentScreen = "Edit Payment Screen";
    static let sendItineraryScreen = "Send Itinerary";
    static let mobileCheckInDetailScreen = "Mobile Check In Detail";
    static let loginMobileCheckInScreen = "Login Mobile Check-In";
    static let mobileCheckInScreen = "Mobile Check-In";
    static let mobileCheckInTermScreen = "Mobile Check In Term";
    static let successCheckInViewScreen = "Success Check In View";
    static let loginBoardingPassScreen = "Login Boarding Pass";
    static let boardingPassScreen = "Boarding Pass";
    static let boardingPassDetailScreen = "Boarding Pass Detail";
    static let facebookScreen = "Facebook Page";
    static let instagramScreen = "Instagram Page";
    static let twitterScreen = "Twitter Page";
    static let loginPopupScreen = "Book Flight: Flight Details(Login Popup)";
    //static let manageFlightErrorScreen = "Manage Flight: Manage Flight(Error Popup)";
    static let passwordExpiredScreen = "Login: Password Expired";
    static let paymentManageWebScreen = "Manage Flight: Payment Details(Payment Web)";
    static let flightManagingSummaryScreen = "Manage Flight: Flight Summary";
    static let addPaymentManageScreen = "Manage Flight: Payment Details(Add Payment)";
    //static let aboutUsScreen = "About Us";
    //static let aboutUsScreen = "About Us";
    
}

class Constant: NSObject {
    
}

func nullIfEmpty(value : AnyObject?) -> AnyObject? {
    if value is NSNull {
        return ""
    } else {
        return value
    }
}

func nilIfEmpty(value : AnyObject?) -> AnyObject? {
    if value == nil {
        return ""
    } else {
        return value
    }
}

func getTitleName(titleCode:String) -> String{
    var titleName = String()
    if (defaults.objectForKey("title") != nil){
        for titleData in titleArray{
            if titleData["title_code"] as! String == titleCode{
                titleName = titleData["title_name"] as! String
            }
        }
    }else{
        titleName = titleCode
    }
    
    return titleName
}

func getCountryName(countryCode:String) -> String{
    var countryName = String()
    
    if (defaults.objectForKey("country") != nil){
        
        for countryData in countryArray{
            if countryData["country_code"] as! String == countryCode{
                countryName = countryData["country_name"] as! String
            }
        }
        
    }else{
        countryName = countryCode
    }
    
    
    return countryName
}

var location = [NSDictionary]()
var travel = [NSDictionary]()
var pickerRow = [String]()
var pickerTravel = [String]()

func getDepartureAirport(module : String){
    
    location = [NSDictionary]()
    pickerRow = [String]()
    
    if (defaults.objectForKey("flight") != nil){
        let flight = defaults.objectForKey("flight") as! [Dictionary<String, AnyObject>]
        var first = flight[0]["location_code"]
        location.append(flight[0] as NSDictionary)
        pickerRow.append("\(flight[0]["location"] as! String) (\(flight[0]["location_code"] as! String))")
        
        for loc in flight{
            
            if loc["location_code"] as! String != first as! String{
                
                if module == "checkIn"{
                    
                    if loc["mobile_check_in"] as! String == "Y"{
                        location.append(loc as NSDictionary)
                        pickerRow.append("\(loc["location"] as! String) (\(loc["location_code"] as! String))")
                        first = loc["location_code"]
                    }
                    
                }else{
                    location.append(loc as NSDictionary)
                    pickerRow.append("\(loc["location"] as! String) (\(loc["location_code"] as! String))")
                    first = loc["location_code"]
                }
                
            }
            
        }
    }
}

func getArrivalAirport(departureAirport: String, module : String){
    
    if (defaults.objectForKey("flight") != nil){
        
        let flight = defaults.objectForKey("flight") as! [Dictionary<String, AnyObject>]

        let first = departureAirport
        
        for loc in flight{
            
            if loc["location_code"] as! String == first{
                
                if module == "checkIn"{
                    
                    if loc["mobile_check_in"] as! String == "Y"{
                        travel.append(loc as NSDictionary)
                        pickerTravel.append("\(loc["travel_location"] as! String) (\(loc["travel_location_code"] as! String))")
                    }
                }else{
                    travel.append(loc as NSDictionary)
                    pickerTravel.append("\(loc["travel_location"] as! String) (\(loc["travel_location_code"] as! String))")
                }
                
            }
            
        }
        
    }
    
}

var alertView = SCLAlertView()

func showHud(status:String){
    
    if status == "open"{
        alertView.showCloseButton = false
        alertView.showWait("Loading...", subTitle: "", colorStyle: 0xEC581A)
    }else{
        alertView.hideView()
        alertView = SCLAlertView()
    }
    
}

func showErrorMessage(message : String){
    
    let errorView = SCLAlertView()
    errorView.showError("Error!", subTitle:message, colorStyle: 0xEC581A, closeButtonTitle : "Close")
    
}

func showRetryMessage(message : String){
    
    let errorView = SCLAlertView()
    errorView.addButton("Retry") { () -> Void in
        InitialLoadManager.sharedInstance.load()
    }
    errorView.showCloseButton = false
    errorView.showError("Error!", subTitle:message, colorStyle: 0xEC581A)
    
}

func showToastMessage(message:String){
    
    let messageView = SCLAlertView()
    messageView.showSuccess("Success", subTitle:message, colorStyle: 0xEC581A, closeButtonTitle : "Close")
    
}

func showNotif(title : String, message:String){
    
    let infoView = SCLAlertView()
    infoView.showInfo(title, subTitle: message, closeButtonTitle: "Close", colorStyle: 0xEC581A)
    
}

func showInfo(message:String){
    
    let infoView = SCLAlertView()
    infoView.showInfo("Info", subTitle: message, closeButtonTitle: "Okay", colorStyle: 0xEC581A)
    
}

var viewsController = UIViewController()

func showLoading(){
    
    let appDelegate = UIApplication.sharedApplication().keyWindow
    let root = appDelegate?.rootViewController
    viewsController = root!
    
    let storyboard = UIStoryboard(name: "Loading", bundle: nil)
    let loadingVC = storyboard.instantiateViewControllerWithIdentifier("LoadingVC") as! LoadingViewController
    loadingVC.view.backgroundColor = UIColor.clearColor()
    
    viewsController.presentViewController(loadingVC, animated: true, completion: nil)
    
}

func hideLoading(){
    
    viewsController.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    
}
