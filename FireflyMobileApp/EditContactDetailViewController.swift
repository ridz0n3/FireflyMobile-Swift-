//
//  EditContactDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class EditContactDetailViewController: CommonContactDetailViewController {

    @IBOutlet weak var continueBtn: UIButton!
    var itineraryData = [String: AnyObject]()
    var insuranceDetails = [String: AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.sharedInstance.logScreen(GAConstants.editContactDetailScreen)
        continueBtn.layer.cornerRadius = 10
        
        itineraryData = defaults.object(forKey: "manageFlight") as! [String : AnyObject]
        contactData = itineraryData["contact_information"] as! Dictionary<String, AnyObject> as! Dictionary<String, String>
        insuranceDetails = itineraryData["insurance_details"]  as! [String : AnyObject]

        views.isHidden = true
        var newFrame = footerView.bounds
        newFrame.size.height = 58
        footerView.frame = newFrame
        
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        
        initializeForm()
    }

    @IBAction func continueBtnPressed(_ sender: AnyObject) {
        validateForm()
        
        if isValidate{
            
            let purposeData = getPurpose(formValues()[Tags.ValidationPurpose]! as! String, purposeArr: purposeArray as [Dictionary<String, AnyObject>])
            let titleData = getTitleCode(formValues()[Tags.ValidationTitle]! as! String, titleArr: titleArray)
            let firstNameData = formValues()[Tags.ValidationFirstName]!  as! String
            let lastNameData = formValues()[Tags.ValidationLastName]! as! String
            let emailData = formValues()[Tags.ValidationUsername]!  as! String
            let countryData = getCountryCode(formValues()[Tags.ValidationCountry]! as! String, countryArr: countryArray)
            let mobileData = formValues()[Tags.ValidationMobileHome]!  as! String
            let alternateData = nullIfEmpty(formValues()[Tags.ValidationAlternate] as AnyObject)  
            let companyNameData = (nullIfEmpty(formValues()[Tags.ValidationCompanyName] as AnyObject)).xmlSimpleEscape
            let address1Data = (nullIfEmpty(formValues()[Tags.ValidationAddressLine1] as AnyObject)).xmlSimpleEscape
            let address2Data = (nullIfEmpty(formValues()[Tags.ValidationAddressLine2] as AnyObject)).xmlSimpleEscape
            let address3Data = (nullIfEmpty(formValues()[Tags.ValidationAddressLine3] as AnyObject)).xmlSimpleEscape
            let cityData = (nullIfEmpty(formValues()[Tags.ValidationTownCity] as AnyObject)).xmlSimpleEscape
            let stateData = getStateCode(nullIfEmpty(formValues()[Tags.ValidationState] as AnyObject) , stateArr: stateArray)
            let postcodeData = nullIfEmpty(formValues()[Tags.ValidationPostcode] as AnyObject)
            
            var pnr = ""
            if let interaryInfo = itineraryData["itinerary_information"] as? Dictionary<String,String>{
                pnr = interaryInfo["pnr"]! as String
            }
            
            let booking_id = "\(itineraryData["booking_id"]!)"
            let signature = "\(itineraryData["signature"]!)"
            
            var insuranceData = ""
            
            if insuranceDetails["status"] as! String == "N"{
                insuranceData = "0"
            }else{
                insuranceData = "1"
            }

            if insuranceData == ""{
                showErrorMessage("To proceed, you need to agree with the Insurance Declaration.")
            }else{
                showLoading() 
                
                var customer_number = String()
                
                if try! LoginManager.sharedInstance.isLogin(){
                    customer_number = defaults.object(forKey: "customer_number") as! String
                }
                
                FireFlyProvider.request(.ChangeContact(booking_id, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signature, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData, pnr, customer_number), completion: { (result) -> () in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                
                                let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                let manageFlightVC = storyboard.instantiateViewController(withIdentifier: "ManageFlightMenuVC") as! ManageFlightHomeViewController
                                manageFlightVC.isConfirm = true
                                manageFlightVC.itineraryData = json.object as! NSDictionary
                                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            }else if json["status"] == "error"{
                                
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
                            hideLoading()
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
    
    func firstButton(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func updateButton(){
        _ = self.navigationController?.popViewController(animated: true)
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
