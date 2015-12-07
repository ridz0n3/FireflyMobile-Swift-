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
import SwiftyJSON
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
        
        if isValidate{
            
            let password = self.formValues()["Password"] as! String
            let encPassword = try! EncryptManager.sharedInstance.aesEncrypt(password, key: key, iv: iv)

            let username: String = self.formValues()["Email"]! as! String

            showHud()
            
            
            FireFlyProvider.request(.Login(username, encPassword), completion: { (result) -> () in
                self.hideHud()
                switch result {
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        if  json["status"].string == "success"{
                            self.showToastMessage(json["status"].string!)
                            let defaults = NSUserDefaults.standardUserDefaults()
                            
                            // let userInfoTemp : NSDictionary<String, JSON> = result["user_info"].dictionary
                            
                            defaults.setObject(json["user_info"].object , forKey: "userInfo")
                            defaults.synchronize()
                            
                            NSNotificationCenter.defaultCenter().postNotificationName("reloadSideMenu", object: nil)
                            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                            let homeVC = storyBoard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
                            self.navigationController!.pushViewController(homeVC, animated: true)
                        }
                    }
                    catch {
                        
                    }
                print (successResult.data)
                case .Failure(let failureResult):
                print (failureResult)
                }
                //var success = error == nil
                }
            )
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
      
        FireFlyProvider.request(.ForgotPassword(self.emailTxtField.text!, "")) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do{
             let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    if json["status"].string == "success"{
                        self.showToastMessage(json["message"].string!)
                        self.forgotPasswordView.removeFromSuperview()
                    }else{
                        self.showToastMessage(json["userInfo"].string!)
                    }
                }
                catch{
                    
                }
            
            case .Failure(let failureResult):
            print(failureResult)
            
            }
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


