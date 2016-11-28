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
    var book = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flightType = defaults.object(forKey: "flightType") as! String
        AnalyticsManager.sharedInstance.logScreen("\(GAConstants.addPaymentScreen) (\(flightType))")
        totalDueLbl.text = String(format: "%.2f MYR", totalDue)//"\(totalDue) MYR"
        
    }
    
    @IBAction func continueBtnPressed(_ sender: AnyObject) {
        let signature = defaults.object(forKey: "signature") as! String
        let bookingID = "\(defaults.object(forKey: "booking_id")!)"
        
        if paymentMethod == "Card"{
            
            validateForm()
            
            if isValidate{
                let cardNumber = self.formValues()[Tags.ValidationCardNumber] as! String
                
                /*if !luhnCheck(cardNumber){
                    showErrorMessage("Invalid credit card")
                }else */if !checkDate(self.formValues()[Tags.ValidationCardExpiredDate] as! String){
                    showErrorMessage("Invalid Date")
                }else{
                    
                    let channelType = "1"
                    let channelCode = getCardTypeCode(self.formValues()[Tags.ValidationCardType] as! String, cardArr: cardType)
                    let cardHolderName = self.formValues()[Tags.ValidationHolderName] as! String
                    let cvv = self.formValues()[Tags.ValidationCcvNumber] as! String
                    let expiredDate = (self.formValues()[Tags.ValidationCardExpiredDate] as! String).components(separatedBy: "/")
                    let issuingBank = self.formValues()[Tags.ValidationCardType] as! String
                    let expirationDateMonth = expiredDate[0]
                    let expirationDateYear = expiredDate[1]
                    var personID = String()
                    var accNumber = String()
                    if try! LoginManager.sharedInstance.isLogin(){
                        let info = self.formValues()[Tags.SaveFamilyAndFriend] as! NSDictionary
                        
                        if info["status"] as! Bool{
                            personID = defaults.object(forKey: "personID") as! String
                            accNumber = cardInfo["account_number_id"] as! String
                        }
                    }
                    
                    showLoading() 
                    FireFlyProvider.request(.PaymentProcess(signature, channelType, channelCode, cardNumber, expirationDateMonth, expirationDateYear, cardHolderName, issuingBank, cvv, bookingID, personID, accNumber), completion: { (result) -> () in
                        
                        switch result {
                        case .success(let successResult):
                            do {
                                let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                                
                                if json["status"] == "Redirect"{
                                    hideLoading()
                                    let urlString = String(format: "%@ios/%@", json["link"].string!,json["pass"].string!)
                                    
                                    let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                    let manageFlightVC = storyboard.instantiateViewController(withIdentifier: "PaymentWebVC") as! PaymentWebViewController
                                    manageFlightVC.paymentType = "Card"
                                    manageFlightVC.urlString = urlString
                                    manageFlightVC.signature = defaults.object(forKey: "signature") as! String
                                    manageFlightVC.book = "book"
                                    self.navigationController!.pushViewController(manageFlightVC, animated: true)
                                    
                                }else if json["status"] == "error"{
                                    
                                    hideLoading()
                                    
                                    showErrorMessage(json["message"].string!)
                                }else if json["status"].string == "401"{
                                    hideLoading()
                                    showErrorMessage(json["message"].string!)
                                    InitialLoadManager.sharedInstance.load()
                                    
                                    for views in (self.navigationController?.viewControllers)!{
                                        if views.classForCoder == HomeViewController.classForCoder(){
                                            _ = self.navigationController?.popToViewController(views, animated: true)
                                            AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                        }
                                    }
                                }
                            }
                            catch {
                                
                            }
                            
                        case .failure(let failureResult):
                            
                            hideLoading()
                            showErrorMessage(failureResult.localizedDescription)
                        }
                        
                        
                    })
                    
                }
                
            }
        }else if paymentMethod == "MU"{
            
            showLoading() 
            FireFlyProvider.request(.PaymentProcess(signature, "2", paymentMethod, "", "", "", "", "", "", bookingID, "", ""), completion: { (result) -> () in
                
                switch result {
                case .success(let successResult):
                    do {
                        let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                        
                        if json["status"] == "Redirect"{
                            
                            let urlString = String(format: "%@ios/%@", json["link"].string!,json["pass"].string!)
                            
                            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                            let manageFlightVC = storyboard.instantiateViewController(withIdentifier: "PaymentWebVC") as! PaymentWebViewController
                            manageFlightVC.paymentType = "MU"
                            manageFlightVC.urlString = urlString
                            manageFlightVC.signature = defaults.object(forKey: "signature") as! String
                            self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            
                        }else if json["status"] == "error"{
                            
                            hideLoading()
                            
                            showErrorMessage(json["message"].string!)
                        }else if json["status"].string == "401"{
                            hideLoading()
                            showErrorMessage(json["message"].string!)
                            InitialLoadManager.sharedInstance.load()
                            
                            for views in (self.navigationController?.viewControllers)!{
                                if views.classForCoder == HomeViewController.classForCoder(){
                                    _ = self.navigationController?.popToViewController(views, animated: true)
                                    AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                }
                            }
                        }
                    }
                    catch {
                        
                    }
                    
                case .failure(let failureResult):
                    
                    hideLoading()
                    showErrorMessage(failureResult.localizedDescription)
                }
                
                
            })
            
        }else if paymentMethod == "CI"{
            
            showLoading() 
            FireFlyProvider.request(.PaymentProcess(signature, "2", paymentMethod, "", "", "", "", "", "", bookingID, "", ""), completion: { (result) -> () in
                
                switch result {
                case .success(let successResult):
                    do {
                        let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                        
                        if json["status"] == "Redirect"{
                            
                            let urlString = String(format: "%@ios/%@", json["link"].string!,json["pass"].string!)
                            
                            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                            let manageFlightVC = storyboard.instantiateViewController(withIdentifier: "PaymentWebVC") as! PaymentWebViewController
                            manageFlightVC.paymentType = "CI"
                            manageFlightVC.urlString = urlString
                            manageFlightVC.signature = defaults.object(forKey: "signature") as! String
                            self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            
                        }else if json["status"] == "error"{
                            
                            hideLoading()
                            
                            showErrorMessage(json["message"].string!)
                        }else if json["status"].string == "401"{
                            hideLoading()
                            showErrorMessage(json["message"].string!)
                            InitialLoadManager.sharedInstance.load()
                            
                            for views in (self.navigationController?.viewControllers)!{
                                if views.classForCoder == HomeViewController.classForCoder(){
                                    _ = self.navigationController?.popToViewController(views, animated: true)
                                    AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                }
                            }
                        }
                    }
                    catch {
                        
                    }
                    
                case .failure(let failureResult):
                    
                    hideLoading()
                    showErrorMessage(failureResult.localizedDescription)
                }
                
                
            })

        }else if paymentMethod == "PX"{
            
            showLoading() 
            FireFlyProvider.request(.PaymentProcess(signature, "2", paymentMethod, "", "", "", "", "", "", bookingID, "", ""), completion: { (result) -> () in
                
                switch result {
                case .success(let successResult):
                    do {
                        let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                        
                        if json["status"] == "Redirect"{
                            
                            let urlString = String(format: "%@ios/%@", json["link"].string!,json["pass"].string!)
                            
                            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                            let manageFlightVC = storyboard.instantiateViewController(withIdentifier: "PaymentWebVC") as! PaymentWebViewController
                            manageFlightVC.paymentType = "PX"
                            manageFlightVC.urlString = urlString
                            manageFlightVC.signature = defaults.object(forKey: "signature") as! String
                            self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            
                        }else if json["status"] == "error"{
                            
                            hideLoading()
                            
                            showErrorMessage(json["message"].string!)
                        }else if json["status"].string == "401"{
                            hideLoading()
                            showErrorMessage(json["message"].string!)
                            InitialLoadManager.sharedInstance.load()
                            
                            for views in (self.navigationController?.viewControllers)!{
                                if views.classForCoder == HomeViewController.classForCoder(){
                                    _ = self.navigationController?.popToViewController(views, animated: true)
                                    AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                }
                            }
                        }
                    }
                    catch {
                        
                    }
                    
                case .failure(let failureResult):
                    
                    hideLoading()
                    showErrorMessage(failureResult.localizedDescription)
                }
                
                
            })

        }
    }

}
