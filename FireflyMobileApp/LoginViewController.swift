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

class LoginViewController: BaseXLFormViewController {

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
            //let parameters:[String:AnyObject] = [
              //  "username": self.formValues()["Email"]!,
               // "password": self.formValues()["Password"]!,
           // ]
            
            let username: String = self.formValues()["Email"]! as! String
            let password: String = self.formValues()["Password"]! as! String
            showHud()
            
            FireFlyProvider.request(.Login(username, password), completion: { (data, statusCode, response, error) -> () in
                var success = error == nil
                self.hideHud()
                if let data = data {
                    do {
                        let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                        if let json = json as? NSArray {
                            // Presumably, you'd parse the JSON into a model object. This is just a demo, so we'll keep it as-is.
                            print(json)
                        } else if let json = json as? NSDictionary{
                            print(json)
                        }
                    } catch {
                        success = false
                    }
                }
                
            })
          /*  FireFlyProvider.request(.Login("test", "test"), completion: { (data, statusCode, response, error) -> () in
                var success = error == nil
                self.hideHud()
                print(result)
            })*/
            /*test.sharedClient().createRequestWithService("Login", withParams: parameters, completion: { (result) -> Void in
                
                self.hideHud()
                print(result)
                
            })*/
            
        }
        
    }
    
    @IBAction func forgotPasswordButtonPressed(sender: AnyObject) {
        
        let forgotPassword = NSBundle.mainBundle().loadNibNamed("ForgotPasswordView", owner: self, options: nil)[0] as! ForgotPasswordView
        
        forgotPassword.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        forgotPassword.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25)
        
        forgotPassword.closedButton.addTarget(self, action: "closeView:", forControlEvents: .TouchUpInside)
        
        let applicationLoadViewIn = CATransition()
        applicationLoadViewIn.type = kCATransitionFade
        applicationLoadViewIn.duration = 2.0
        applicationLoadViewIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        forgotPassword.layer.addAnimation(applicationLoadViewIn, forKey: kCATransitionReveal)
        self.view.addSubview(forgotPassword)
        
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let registerVC = storyboard.instantiateViewControllerWithIdentifier("RegisterVC")
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }

    func closeView(sender : UIButton){
        sender.superview?.removeFromSuperview()
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
