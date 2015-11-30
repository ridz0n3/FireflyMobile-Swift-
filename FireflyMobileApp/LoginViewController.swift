//
//  LoginViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import Alamofire
import XLForm
import SwiftValidator

class LoginViewController: BaseXLFormViewController {

    @IBOutlet var forgotPasswordView: UIView!
    @IBOutlet weak var emailTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        
        form = XLFormDescriptor(title: "")
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Enter Email"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword, rowType: XLFormRowDescriptorTypePassword, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Password"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        validateForm()
        
        let key = "owNLfnLjPvwbQH3hUmj5Wb7wBIv83pR7" // length == 3
        let iv = "owNLfnLjPvwbQH3h"// lenght == 16
        let s = "Abc987330"
        let enc = try! s.aesEncrypt(key, iv: iv)
        let dec = try! enc.aesDecrypt(key, iv: iv)
        print(s) //string to encrypt
        //print("iv:\(iv2)")
        print("enc:\(enc)") //2r0+KirTTegQfF4wI8rws0LuV8h82rHyyYz7xBpXIpM=
        print("dec:\(dec)") //string to encrypt
        print("\(s == dec)") //true
        /*
        let parameters:[String:AnyObject] = [
            "data": enc,
        ]
        
        let manager = WSDLNetworkManager()
        
        manager.sharedClient().createRequestWithService("Test", withParams: parameters) { (result) -> Void in
            print(result)
            
            let s = "Abc987330"
            let enc = try! s.aesEncrypt(key, iv: iv)
            let dec = try! enc.aesDecrypt(key, iv: iv)
            
            print("\(result["result_decrypt_from_mobile"] as! String == dec)")
            
        }*/
        
        if isValidate{
            
            let parameters:[String:AnyObject] = [
                "username": self.formValues()["Email"]!,
                "password": self.formValues()["Password"]!,
            ]
            
            let manager = WSDLNetworkManager()
            showHud()
            
            manager.sharedClient().createRequestWithService("Login", withParams: parameters, completion: { (result) -> Void in
                self.hideHud()
                
                if result["status"] as! String == "success"{
                    self.showToastMessage(result["status"] as! String)
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(result["user_info"], forKey: "userInfo")
                    defaults.synchronize()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadSideMenu", object: nil)
                    
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let homeVC = storyBoard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
                    self.navigationController!.pushViewController(homeVC, animated: true)
                }else if result["status"] as! String == "change_password"{
                    
                }else{
                    self.showToastMessage(result["message"] as! String)
                }
                
            })
            
        }else{
           // showToastMessage("Please Fill All Field")
        }
        
    }
    
    @IBAction func forgotPasswordButtonPressed(sender: AnyObject) {
        

        forgotPasswordView = NSBundle.mainBundle().loadNibNamed("ForgotPasswordView", owner: self, options: nil)[0] as! UIView
        
        forgotPasswordView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        forgotPasswordView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        
        validator.registerField(emailTxtField, rules: [RequiredRule(), EmailRule()])
        addToolBar(self.emailTxtField)
        
        let applicationLoadViewIn = CATransition()
        applicationLoadViewIn.type = kCATransitionFade
        applicationLoadViewIn.duration = 2.0
        applicationLoadViewIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        forgotPasswordView.layer.addAnimation(applicationLoadViewIn, forKey: kCATransitionReveal)
        self.view.addSubview(forgotPasswordView)
        
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let registerVC = storyboard.instantiateViewControllerWithIdentifier("RegisterVC")
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }

    @IBAction func sendDetail(sender: AnyObject) {
        validator.validate(self)
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        sender.superview?!.removeFromSuperview()
    }
    
    
    override func validationSuccessful() {
       // print(self.emailTxtField.text)
        
        let parameters:[String:AnyObject] = [
            "username": self.emailTxtField.text!,
            "signature": "",
        ]
        
        let manager = WSDLNetworkManager()
        showHud()
        
        manager.sharedClient().createRequestWithService("ForgotPassword", withParams: parameters, completion: { (result) -> Void in
            self.hideHud()
            
            if result["status"] as! String == "success"{
                self.showToastMessage(result["message"] as! String)
                self.forgotPasswordView.removeFromSuperview()
            }else{
                self.showToastMessage(result["userInfo"] as! String)
            }
            
        })

        
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
