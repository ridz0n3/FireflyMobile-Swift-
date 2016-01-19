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
    var itineraryData = NSDictionary()
    var insuranceDetails = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        
        itineraryData = defaults.objectForKey("manageFlight") as! NSDictionary
        contactData = itineraryData["contact_information"] as! NSDictionary
        insuranceDetails = itineraryData["insurance_details"] as! NSDictionary
        
        if insuranceDetails["status"] as! String == "N"{
            views.hidden = true
            var newFrame = footerView.bounds
            newFrame.size.height = 58
            footerView.frame = newFrame
        }
        
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = footerView
        
        initializeForm()
    }

    @IBAction func continueBtnPressed(sender: AnyObject) {
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
            let companyNameData = nilIfEmpty(formValues()[Tags.ValidationCompanyName])!  as! String
            let address1Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine1])!  as! String
            let address2Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine2])!  as! String
            let address3Data = nilIfEmpty(formValues()[Tags.ValidationAddressLine3])!  as! String
            let cityData = nilIfEmpty(formValues()[Tags.ValidationTownCity])!  as! String
            let stateData = getStateCode(nilIfEmpty(formValues()[Tags.ValidationState])! as! String, stateArr: stateArray)
            let postcodeData = nilIfEmpty(formValues()[Tags.ValidationPostcode])!  as! String
            
            let pnr = "\(itineraryData["itinerary_information"]!["pnr"])"
            let booking_id = "\(itineraryData["booking_id"]!)"
            let signature = "\(itineraryData["signature"]!)"
            
            var insuranceData = ""
            
            if insuranceDetails["status"] as! String == "N"{
                insuranceData = "0"
            }else{
                insuranceData = "1"
            }

            if insuranceData == ""{
                showToastMessage("To proceed, you need to agree with the Insurance Declaration.")
            }else{
                showHud()
                
                FireFlyProvider.request(.ChangeContact(booking_id, insuranceData, purposeData, titleData, firstNameData , lastNameData , emailData , countryData, mobileData, alternateData , signature, companyNameData, address1Data, address2Data, address3Data, cityData, stateData, postcodeData, pnr), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do {
                            self.hideHud()
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                self.showToastMessage(json["status"].string!)
                                
                                let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                                manageFlightVC.isConfirm = true
                                manageFlightVC.itineraryData = json.object as! NSDictionary
                                self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            }else{
                                //self.showToastMessage(json["message"].string!)
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
    
    func firstButton(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateButton(){
        self.navigationController?.popViewControllerAnimated(true)
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
