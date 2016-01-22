//
//  AddPaymentViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/19/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddPaymentViewController: CommonPaymentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        totalDueLbl.text = "\(totalDue) MYR"
        
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        if paymentMethod == "Card"{
            
            validateForm()
            
            if isValidate{
                let cardNumber = self.formValues()[Tags.ValidationCardNumber] as! String
                
                if !luhnCheck(cardNumber){
                    self.showToastMessage("Invalid credit card")
                }else if !checkDate(self.formValues()[Tags.ValidationCardExpiredDate] as! String){
                    self.showToastMessage("Invalid Date")
                }else{
                    
                    let signature = defaults.objectForKey("signature") as! String
                    let bookingID = "\(defaults.objectForKey("booking_id")!)"
                    let channelType = "1"
                    let channelCode = getCardTypeCode(self.formValues()[Tags.ValidationCardType] as! String, cardArr: cardType)
                    let cardHolderName = self.formValues()[Tags.ValidationHolderName] as! String
                    let cvv = self.formValues()[Tags.ValidationCcvNumber] as! String
                    let expiredDate = (self.formValues()[Tags.ValidationCardExpiredDate] as! String).componentsSeparatedByString("/")
                    let issuingBank = self.formValues()[Tags.ValidationCardType] as! String
                    let expirationDateMonth = expiredDate[0]
                    let expirationDateYear = expiredDate[1]
                    
                    
                    showHud()
                    FireFlyProvider.request(.PaymentProcess(signature, channelType, channelCode, cardNumber, expirationDateMonth, expirationDateYear, cardHolderName, issuingBank, cvv, bookingID), completion: { (result) -> () in
                        
                        self.hideHud()
                        switch result {
                        case .Success(let successResult):
                            do {
                                self.hideHud()
                                let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                
                                if json["status"] == "Redirect"{
                                    self.showToastMessage(json["status"].string!)
                                    
                                    //let pass = json["pass"].string?.componentsSeparatedByString("/")
                                    let urlString = String(format: "%@/ios/%@", json["link"].string!,json["pass"].string!)
                                    
                                    let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                    let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("PaymentWebVC") as! PaymentWebViewController
                                    manageFlightVC.urlString = urlString
                                    manageFlightVC.signature = defaults.objectForKey("signature") as! String
                                    self.navigationController!.pushViewController(manageFlightVC, animated: true)
                                    
                                }else{
                                    self.showToastMessage(json["message"].string!)
                                }
                            }
                            catch {
                                
                            }
                            print (successResult.data)
                        case .Failure(let failureResult):
                            print (failureResult)
                        }
                        
                        
                    })
                    
                }
                
            }
        }
    }

}
