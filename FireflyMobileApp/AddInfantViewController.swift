//
//  AddInfantViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/13/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddInfantViewController: CommonInfantViewController {

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
            
            let userInfo = defaults.object(forKey: "userInfo")
            let email = userInfo!["username"] as! String
            let title = ""
            let firstName = formValues()[Tags.ValidationFirstName] as! String
            let lastName = formValues()[Tags.ValidationLastName] as! String
            let gender = getGenderCode(formValues()[Tags.ValidationGender] as! String, genderArr: genderArray as [Dictionary<String, AnyObject>])
            let date = formValues()[Tags.ValidationDate]! as! String
            //var arrangeDate = date.components(separatedBy: "-")
            let dob = date//"\(arrangeDate[2])-\(arrangeDate[1])-\(arrangeDate[0])"
            
            let country = getCountryCode(formValues()[Tags.ValidationCountry] as! String, countryArr: countryArray)
            let type = infantInfo["type"] as! String
            let bonuslink = ""
            let familyId = infantInfo["id"] as! Int
            
            showLoading()
            
            if action == "add"{
                FireFlyProvider.request(.AddFamilyAndFriend(email, title, gender, firstName, lastName, dob, country, type, bonuslink), completion: { (result) in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                showToastMessage(json["message"].string!)
                                self.saveFamilyAndFriend(json["family_and_friend"].arrayObject!)
                                NotificationCenter.default.post(name: "reloadList", object: nil)
                                
                                self.navigationController?.popViewControllerAnimated(true)
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
            }else{
                FireFlyProvider.request(.EditFamilyAndFriend(email, title, gender, firstName, lastName, dob, country, type, bonuslink , familyId), completion: { (result) in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                showToastMessage(json["message"].string!)
                                self.saveFamilyAndFriend(json["family_and_friend"].arrayObject!)
                                NotificationCenter.default.post(name: "reloadList", object: nil)
                                
                                self.navigationController?.popViewControllerAnimated(true)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
