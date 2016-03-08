//
//  AddContactDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox
import SwiftyJSON

class AddContactDetailViewController: CommonContactDetailViewController {

    @IBOutlet weak var chooseSeatBtn: UIButton!
    @IBOutlet weak var paymentBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentBtn.layer.cornerRadius = 10
        chooseSeatBtn.layer.cornerRadius = 10
        chooseSeatBtn.layer.borderWidth = 1
        chooseSeatBtn.layer.borderColor = UIColor.orangeColor().CGColor
        
        if defaults.objectForKey("flightType") as! String == "MH"{
            chooseSeatBtn.hidden = true
            paymentBtn.setTitle("Continue", forState: UIControlState.Normal)
        }
        
        if try! LoginManager.sharedInstance.isLogin(){
            
            let userInfo = defaults.objectForKey("userInfo") as! NSDictionary
            contactData = ["address1" : "" ,
                "address2" : "",
                "address3" : "",
                "alternate_phone" : "\(userInfo["contact_alternate_phone"]!)",
                "city" : "",
                "company_name" : "",
                "country" : "\(userInfo["contact_country"]!)",
                "email" : "\(userInfo["contact_email"]!)",
                "first_name" : "\(userInfo["first_name"]!)",
                "last_name" : "\(userInfo["last_name"]!)",
                "mobile_phone" : "\(userInfo["contact_mobile_phone"]!)",
                "postcode" : "",
                "state" : "",
                "title" : "\(userInfo["title"]!)",
                "travel_purpose" : ""]
            
        }
        
        if defaults.objectForKey("insurance_status")?.classForCoder == NSString.classForCoder(){
            
            views.hidden = true
            var newFrame = footerView.bounds
            newFrame.size.height = 98
            footerView.frame = newFrame
            
        }else{
            
            var newFrame = footerView.bounds
            newFrame.size.height = 750
            footerView.frame = newFrame
            
            let insuranceData = defaults.objectForKey("insurance_status") as! NSDictionary
            let insuranceArr = insuranceData["html"] as! NSArray
            var index = 0
            var str = ""
            for text in insuranceArr{
                
                if index == 0{
                    
                    let separate = text.componentsSeparatedByString("</html>")
                    
                    str += "\(separate[0])<br>"
                    
                }else if index == 1{
                    let separate = text.componentsSeparatedByString("<html>")
                    
                    str += "\(separate[1])"
                    
                    paragraph1.attributedText = str.html2String
                    
                }else if index == 2{
                    paragraph2.attributedText = (text as! String).html2String
                }else{
                    paragraph3.attributedText = (text as! String).html2String
                }
                
                index++
                
            }
            
        }
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        
        initializeForm()
    }
    
    @IBAction func continuePaymentBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            
            let purposeData = getPurpose(formValues()[Tags.ValidationPurpose]! as! String, purposeArr: purposeArray)
            let titleData = getTitleCode(formValues()[Tags.ValidationTitle]! as! String, titleArr: titleArray)
            let firstNameData = formValues()[Tags.ValidationFirstName]!  as! String
            let lastNameData = formValues()[Tags.ValidationLastName]! as! String
            let emailData = formValues()[Tags.ValidationUsername]!  as! String
            let countryData = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
            let mobileData = formValues()[Tags.ValidationMobileHome]!  as! String
            let alternateData = nullIfEmpty(formValues()[Tags.ValidationAlternate])!  as! String
            let signatureData = defaults.objectForKey("signature")!  as! String
            let bookIdData = String(format: "%i", defaults.objectForKey("booking_id")!.integerValue)
            let companyNameData = (nilIfEmpty(formValues()[Tags.ValidationCompanyName])!  as! String).xmlSimpleEscapeString()
            let address1Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine1])!  as! String).xmlSimpleEscapeString()
            let address2Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine2])!  as! String).xmlSimpleEscapeString()
            let address3Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine3])!  as! String).xmlSimpleEscapeString()
            let cityData = (nilIfEmpty(formValues()[Tags.ValidationTownCity])!  as! String).xmlSimpleEscapeString()
            let stateData = getStateCode(nilIfEmpty(formValues()[Tags.ValidationState])! as! String, stateArr: stateArray)
            let postcodeData = nilIfEmpty(formValues()[Tags.ValidationPostcode])!  as! String
            
            var insuranceData = ""
            
            if defaults.objectForKey("insurance_status")?.classForCoder == NSString.classForCoder(){
                insuranceData = "0"
            }else{
                if agreeTerm.checkState.rawValue == 1{
                    insuranceData = "\(agreeTerm.checkState.rawValue)"
                }
            }
            
            if insuranceData == ""{
                showErrorMessage("To proceed, you need to agree with the Insurance Declaration.")
            }else{
                showHud("open")
                
                FireFlyProvider.request(.ContactDetail(bookIdData, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signatureData, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData, "N"), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            showHud("close")
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                defaults.setObject(json.dictionaryObject, forKey: "itenerary")
                                defaults.synchronize()
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let paymentVC = storyboard.instantiateViewControllerWithIdentifier("PaymentSummaryVC") as! PaymentSummaryViewController
                                self.navigationController!.pushViewController(paymentVC, animated: true)
                            }else if json["status"] == "error"{
                                showErrorMessage(json["message"].string!)
                            }
                        }
                        catch {
                            
                        }
                        
                    case .Failure(let failureResult):
                        showHud("close")
                        showErrorMessage(failureResult.nsError.localizedDescription)
                    }
                    
                })
            }
            
        }else{
            showErrorMessage("Please fill all fields")
        }
        
    }
    
    @IBAction func continueChooseSeatBtnPressed(sender: AnyObject) {
        validateForm()
        
        if isValidate{
            
            let purposeData = getPurpose(formValues()[Tags.ValidationPurpose]! as! String, purposeArr: purposeArray)
            let titleData = getTitleCode(formValues()[Tags.ValidationTitle]! as! String, titleArr: titleArray)
            let firstNameData = formValues()[Tags.ValidationFirstName]!  as! String
            let lastNameData = formValues()[Tags.ValidationLastName]! as! String
            let emailData = formValues()[Tags.ValidationUsername]!  as! String
            let countryData = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
            let mobileData = formValues()[Tags.ValidationMobileHome]!  as! String
            let alternateData = nullIfEmpty(formValues()[Tags.ValidationAlternate])!  as! String
            let signatureData = defaults.objectForKey("signature")!  as! String
            let bookIdData = String(format: "%i", defaults.objectForKey("booking_id")!.integerValue)
            let companyNameData = (nilIfEmpty(formValues()[Tags.ValidationCompanyName])!  as! String).xmlSimpleEscapeString()
            let address1Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine1])!  as! String).xmlSimpleEscapeString()
            let address2Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine2])!  as! String).xmlSimpleEscapeString()
            let address3Data = (nilIfEmpty(formValues()[Tags.ValidationAddressLine3])!  as! String).xmlSimpleEscapeString()
            let cityData = (nilIfEmpty(formValues()[Tags.ValidationTownCity])!  as! String).xmlSimpleEscapeString()
            let stateData = getStateCode(nilIfEmpty(formValues()[Tags.ValidationState])! as! String, stateArr: stateArray)
            let postcodeData = nilIfEmpty(formValues()[Tags.ValidationPostcode])!  as! String
            
            var insuranceData = ""
            
            if defaults.objectForKey("insurance_status")?.classForCoder == NSString.classForCoder(){
                insuranceData = "0"
            }else{
                if agreeTerm.checkState.rawValue == 1{
                    insuranceData = "\(agreeTerm.checkState.rawValue)"
                }
            }
            
            if insuranceData == ""{
                showErrorMessage("To proceed, you need to agree with the Insurance Declaration.")
            }else{
                showHud("open")
                FireFlyProvider.request(.ContactDetail(bookIdData, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signatureData, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData, "Y" ), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            showHud("close")
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                defaults.setObject(json["journeys"].arrayObject, forKey: "journey")
                                defaults.setObject(json["passengers"].arrayObject, forKey: "passenger")
                                defaults.synchronize()
                                let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                let chooseSeatVC = storyboard.instantiateViewControllerWithIdentifier("SeatSelectionVC") as! AddSeatSelectionViewController
                                self.navigationController!.pushViewController(chooseSeatVC, animated: true)
                            }else if json["status"] == "error"{
                                //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                            }
                        }
                        catch {
                            
                        }
                        
                    case .Failure(let failureResult):
                        showHud("close")
                        showErrorMessage(failureResult.nsError.localizedDescription)
                    }
                    
                })
            }
        }else{
            showErrorMessage("Please fill all fields")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
