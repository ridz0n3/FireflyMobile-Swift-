//
//  PasswordExpiredViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/27/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import SwiftValidator

class PasswordExpiredViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var PasswordExpiredTableView: UITableView!
    
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var passwordsTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()

        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
       
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = PasswordExpiredTableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! CustomPasswordExpiredTableViewCell
            //self.PasswordExpiredTableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! CustomPasswordExpiredTableViewCell
            
            cell.userlbl.text = "UserEmail:*"
            validator.registerField(cell.emailTxt , rules: [RequiredRule(), EmailRule()])
            cell.emailTxt.tag = indexPath.row
            addToolBar(cell.emailTxt)
            return cell
            
        }else{
            
            let cell = self.PasswordExpiredTableView.dequeueReusableCellWithIdentifier("PasswordCell", forIndexPath: indexPath) as! CustomPasswordExpiredTableViewCell
            
            if indexPath.row == 1 {
                cell.password.text = "Current Password:*"
                validator.registerField(cell.passwordTxt, rules: [RequiredRule(), PasswordRule(regex: "^(?=.*[a-zA-Z0-9])[a-zA-Z0-9][^,.~]{8,16}$", message: "Invalid pss")])
                cell.passwordTxt.tag = indexPath.row
                addToolBar(cell.passwordTxt)
            }else if indexPath.row == 2 {
                cell.password.text = "New Password:*"
                validator.registerField(cell.passwordTxt, rules: [RequiredRule(), PasswordRule(regex: "^(?=.*[a-zA-Z0-9])[a-zA-Z0-9][^,.~]{8,16}$", message: "Invalid pss")])

                cell.passwordTxt.tag = indexPath.row
                addToolBar(cell.passwordTxt)
            }else{
                cell.password.text = "Confirm Password:*"
                // validataion  against other fields using ConfirmRule
                validator.registerField(cell.passwordTxt, rules: [ConfirmationRule(confirmField: cell.passwordTxt)])
                cell.passwordTxt.tag = indexPath.row
                addToolBar(cell.passwordTxt)
            }
            
            return cell;
        }
        
    }

    @IBAction func ContinueBtn(sender: AnyObject) {
         validator.validate(self)
    }
    override func validationSuccessful() {
        // print(self.emailTxtField.text)
        
        let parameters:[String:AnyObject] = [
            "username": self.userTxtField.text!,
            "signature": "",
        ]
        
        let manager = WSDLNetworkManager()
        showHud()
        
        manager.sharedClient().createRequestWithService("ForgotPassword", withParams: parameters, completion: { (result) -> Void in
            self.hideHud()
            
            if result["status"].string == "success"{
                self.showToastMessage(result["message"].string!)
                self.PasswordExpiredTableView.removeFromSuperview()
            }else{
                self.showToastMessage(result["userInfo"].string!)
            }
            
        })
        
        
    }

    
    override func validationFailed(errors: [UITextField : ValidationError]) {
        showToastMessage("msg")
        
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
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
