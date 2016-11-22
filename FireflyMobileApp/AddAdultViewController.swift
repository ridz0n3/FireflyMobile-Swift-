//
//  AddAdultViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/7/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddAdultViewController: CommonAdultViewController {

    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate{
            
            let userInfo = defaults.object(forKey: "userInfo") as! NSDictionary
            let email = userInfo["username"] as! String
            let title = getTitleCode(formValues()[Tags.ValidationTitle] as! String, titleArr: titleArray)
            let firstName = formValues()[Tags.ValidationFirstName] as! String
            let lastName = formValues()[Tags.ValidationLastName] as! String
            
            let date = formValues()[Tags.ValidationDate]! as! String
            //var arrangeDate = date.components(separatedBy: "-")
            let dob = date//"\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])"
            
            let country = getCountryCode(formValues()[Tags.ValidationCountry] as! String, countryArr: countryArray)
            let type = adultInfo["type"] as! String
            let bonuslink = nullIfEmpty(formValues()[Tags.ValidationEnrichLoyaltyNo] as AnyObject)
            let familyId = adultInfo["id"] as! Int
            
            showLoading()
            
            if action == "add"{
                FireFlyProvider.request(.AddFamilyAndFriend(email, title, "", firstName, lastName, dob, country, type, bonuslink ), completion: { (result) in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                showToastMessage(json["message"].string!)
                                self.saveFamilyAndFriend(familyAndFriendInfo: json["family_and_friend"].arrayObject! as [AnyObject])
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadList"), object: nil)
                                
                                self.navigationController?.popViewController(animated: true)
                            }else if json["status"] == "error"{
                                showErrorMessage(json["message"].string!)
                            }else if json["status"].string == "401"{
                                hideLoading()
                                showErrorMessage(json["message"].string!)
                                InitialLoadManager.sharedInstance.load()
                                
                                for views in (self.navigationController?.viewControllers)!{
                                    if views.classForCoder == HomeViewController.classForCoder(){
                                        self.navigationController?.popToViewController(views, animated: true)
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
            }else{
                FireFlyProvider.request(.EditFamilyAndFriend(email, title, "", firstName, lastName, dob, country, type, bonuslink , familyId), completion: { (result) in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                showToastMessage(json["message"].string!)
                                self.saveFamilyAndFriend(familyAndFriendInfo: json["family_and_friend"].arrayObject! as [AnyObject])
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadList"), object: nil)
                                
                                self.navigationController?.popViewController(animated: true)
                            }else if json["status"] == "error"{
                                showErrorMessage(json["message"].string!)
                            }else if json["status"].string == "401"{
                                hideLoading()
                                showErrorMessage(json["message"].string!)
                                InitialLoadManager.sharedInstance.load()
                                
                                for views in (self.navigationController?.viewControllers)!{
                                    if views.classForCoder == HomeViewController.classForCoder(){
                                        self.navigationController?.popToViewController(views, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
