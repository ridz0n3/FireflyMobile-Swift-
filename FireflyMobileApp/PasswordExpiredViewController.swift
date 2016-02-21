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
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        //current password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Current Password:*")
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "The password must contain \n (number, symbol, uppercase, lowercase)", andRegexString: "^(?=.*[a-zA-Z0-9])[a-zA-Z0-9][^,.~]{8,16}$"))
        section.addFormRow(row)
        
        //new password
        row = XLFormRowDescriptor(tag: Tags.ValidationNewPassword, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"New Password:*")
        row.required = true
        row.addValidator(XLFormRegexValidator(msg: "The password must contain \n (number, symbol, uppercase, lowercase)", andRegexString: "^(?=.*[a-zA-Z0-9])[a-zA-Z0-9][^,.~]{8,16}$"))
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
                
                showHud("open")
                FireFlyProvider.request(.ChangePassword(userId, currentPasswordEnc, newPasswordEnc), completion: { (result) -> () in
                    
                    switch result {
                    case .Success(let successResult):
                        do{
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                let info = json["user_info"].dictionaryObject
                                FireFlyProvider.request(.Login(info!["username"] as! String, info!["password"] as! String), completion: { (result) -> () in
                                    showHud("close")
                                    switch result {
                                    case .Success(let successResult):
                                        do {
                                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                                            
                                            if  json["status"] == "success"{
                                                showToastMessage("Successfully change password")
                                                defaults.setObject(json["user_info"]["signature"].string, forKey: "signatureLoad")
                                                defaults.setObject(json["user_info"].object , forKey: "userInfo")
                                                defaults.synchronize()
                                                
                                                NSNotificationCenter.defaultCenter().postNotificationName("reloadSideMenu", object: nil)
                                                let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                                                let homeVC = storyBoard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
                                                self.navigationController!.pushViewController(homeVC, animated: true)
                                            }else if json["status"] == "change_password" {
                                                //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                                                let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                                                let homeVC = storyBoard.instantiateViewControllerWithIdentifier("PasswordExpiredVC") as! PasswordExpiredViewController
                                                self.navigationController!.pushViewController(homeVC, animated: true)
                                            }else if json["status"] == "error"{
                                                //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                                            }
                                        }
                                        catch {
                                            
                                        }
                                        
                                    case .Failure(let failureResult):
                                        print (failureResult)
                                    }
                                    //var success = error == nil
                                    }
                                )
                                
                                
                            }else if json["status"] == "error"{
                                showHud("close")
                                //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                            }
                        }
                        catch{
                            
                        }
                        
                    case .Failure(let failureResult):
                        print(failureResult)
                        
                    }
                    
                })
                
                
            }
            
        }
        
    }
    
    override func validateForm() {
        let array = formValidationErrors()
        
        if array.count != 0{
            isValidate = false
            
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                
                if self.tableView.cellForRowAtIndexPath(index) != nil{
                    let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledTextFieldCell
                    
                    let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                    cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                    
                    animateCell(cell)
                }
            }
        }else{
            isValidate = true
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
