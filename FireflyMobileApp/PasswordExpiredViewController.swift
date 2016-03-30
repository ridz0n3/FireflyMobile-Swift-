//
//  PasswordExpiredViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/16/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON

class PasswordExpiredViewController: BaseXLFormViewController {
    
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        initializeForm()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        let section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        //email
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Email Address:*")
        row.required = true
        row.value = email
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        //current password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Current Password:*")
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "Password must be at least 8 characters, no more than 16 characters, must include at least one upper case letter, one lower case letter, one numeric digit, and one non-alphanumeric. The password cannot contain a period(.) comma(,) or tilde(~).", andRegexString: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=-])(?=\\S+$).{8,16}$"))
        section.addFormRow(row)
        
        //new password
        row = XLFormRowDescriptor(tag: Tags.ValidationNewPassword, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"New Password:*")
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "Password must be at least 8 characters, no more than 16 characters, must include at least one upper case letter, one lower case letter, one numeric digit, and one non-alphanumeric. The password cannot contain a period(.) comma(,) or tilde(~).", andRegexString: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=-])(?=\\S+$).{8,16}$"))
        section.addFormRow(row)
        
        //confirm password
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmPassword, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Confirm Password:*")
        row.required = true
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    @IBAction func ContinueBtnPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate{
            
            if formValues()[Tags.ValidationNewPassword]! as! String != formValues()[Tags.ValidationConfirmPassword]! as! String{
                showErrorMessage("Confirm password incorrect")
            }else{
                
                let currentPasswordEnc = try! EncryptManager.sharedInstance.aesEncrypt(formValues()[Tags.ValidationPassword]! as! String, key: key, iv: iv)
                let newPasswordEnc = try! EncryptManager.sharedInstance.aesEncrypt(formValues()[Tags.ValidationNewPassword]! as! String, key: key, iv: iv)
                let userId = formValues()[Tags.ValidationEmail] as! String
                
                showLoading() 
                FireFlyProvider.request(.ChangePassword(userId, currentPasswordEnc, newPasswordEnc), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do{
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                let info = json["user_info"].dictionaryObject
                                FireFlyProvider.request(.Login(info!["username"] as! String, info!["password"] as! String), completion: { (result) -> () in
                                    
                                    switch result {
                                    case .Success(let successResult):
                                        do {
                                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                            
                                            if  json["status"] == "success"{
                                                showToastMessage("Password successfully change")
                                                defaults.setObject(json["user_info"]["signature"].string, forKey: "signatureLoad")
                                                defaults.setObject(json["user_info"].object , forKey: "userInfo")
                                                defaults.synchronize()
                                                
                                                NSNotificationCenter.defaultCenter().postNotificationName("reloadSideMenu", object: nil)
                                                let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                                                let homeVC = storyBoard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
                                                self.navigationController!.pushViewController(homeVC, animated: true)
                                            }else if json["status"] == "change_password" {
                                                
                                showErrorMessage(json["message"].string!)
                                                let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                                                let homeVC = storyBoard.instantiateViewControllerWithIdentifier("PasswordExpiredVC") as! PasswordExpiredViewController
                                                self.navigationController!.pushViewController(homeVC, animated: true)
                                            }else if json["status"] == "error"{
                                                
                                showErrorMessage(json["message"].string!)
                                            }
                                            hideLoading()
                                        }
                                        catch {
                                            
                                        }
                                        
                                    case .Failure(let failureResult):
                                        hideLoading()
                                        showErrorMessage(failureResult.nsError.localizedDescription)
                                    }
                                    //var success = error == nil
                                    }
                                )
                                
                                
                            }else if json["status"] == "error"{
                                
                                hideLoading()
                                
                                showErrorMessage(json["message"].string!)
                            }
                        }
                        catch{
                            
                        }
                        
                    case .Failure(let failureResult):
                        
                        hideLoading()
                        showErrorMessage(failureResult.nsError.localizedDescription)
                        
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
