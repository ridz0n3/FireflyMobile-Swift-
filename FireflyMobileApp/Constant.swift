//
//  Constant.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/20/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

let defaults = NSUserDefaults.standardUserDefaults()
let key = "owNLfnLjPvwbQH3hUmj5Wb7wBIv83pR7" // length == 3
let iv = "owNLfnLjPvwbQH3h" // length == 16
let kBaseURL = "http://fyapidev.me-tech.com.my/api"
let estimote_uuid = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
let virtual_uuid = NSUUID(UUIDString: "8492E75F-4FD6-469D-B132-043FE94921D8")


var purposeArray = [["purpose_code":"1","purpose_name":"Leisure"],["purpose_code":"2","purpose_name":"Business"]]
var travelDoc = [["doc_code":"P","doc_name":"Passport"],["doc_code":"NRIC","doc_name":"Malaysia IC"],["doc_code":"V","doc_name":"Travel VISA"]]
var genderArray = [["gender_code":"Female","gender_name":"Female"],["gender_code":"Male","gender_name":"Male"]]
var titleArray = defaults.objectForKey("title") as! NSMutableArray
var countryArray = defaults.objectForKey("country") as! NSMutableArray

extension String {
    var html2String:NSAttributedString {
        return try! NSAttributedString(data:dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
    }
}

extension UIViewController: UITextFieldDelegate{
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.blueColor()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelPressed")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
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
    for titleData in titleArray{
        if titleData["title_code"] as! String == titleCode{
            titleName = titleData["title_name"] as! String
        }
    }
    
    return titleName
}

func getCountryName(countryCode:String) -> String{
    var countryName = String()
    for countryData in countryArray{
        if countryData["country_code"] as! String == countryCode{
            countryName = countryData["country_name"] as! String
        }
    }
    
    return countryName
}

var location = [NSDictionary]()
var travel = [NSDictionary]()
var pickerRow = [String]()
var pickerTravel = [String]()

func getDepartureAirport(){
    
    let flight = defaults.objectForKey("flight") as! NSMutableArray
    var first = flight[0]["location_code"]
    location.append(flight[0] as! NSDictionary)
    pickerRow.append(flight[0]["location"] as! String)
    for loc in flight{
        
        if loc["location_code"] as! String != first as! String{
            location.append(loc as! NSDictionary)
            pickerRow.append(loc["location"] as! String)
            first = loc["location_code"]
        }
        
    }
    
}

func getArrivalAirport(departureAirport: String){
    
    let flight = defaults.objectForKey("flight") as! NSMutableArray
    let first = departureAirport
    
    for loc in flight{
        
        if loc["location_code"] as! String == first{
            travel.append(loc as! NSDictionary)
            pickerTravel.append(loc["travel_location"] as! String)
        }
        
    }
}


