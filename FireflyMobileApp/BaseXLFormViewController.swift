//
//  BaseXLFormViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/18/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import MBProgressHUD
import XLForm
import SwiftValidator

var isValidate: Bool = false

class BaseXLFormViewController: XLFormViewController, MBProgressHUDDelegate, ValidationDelegate {
    
    var HUD : MBProgressHUD = MBProgressHUD()
    let validator = Validator()
    
    internal struct Tags {
        static let ValidationUsername = "Email"
        static let ValidationPassword = "Password"
        static let ValidationNewPassword = "New Password"
        static let ValidationConfirmPassword = "Confirm Password"
        static let ValidationTitle = "Title"
        static let ValidationFirstName = "First Name"
        static let ValidationLastName = "Last Name"
        static let ValidationDate = "Date"
        static let ValidationAddressLine1 = "Address Line 1"
        static let ValidationAddressLine2 = "Address Line 2"
        static let ValidationCountry = "Country"
        static let ValidationTownCity = "Town/City"
        static let ValidationState = "State"
        static let ValidationPostcode = "Postcode"
        static let ValidationMobileHome = "Mobile/Home"
        static let ValidationAlternate = "Alternate"
        static let ValidationFax = "Fax"
        static let ValidationEmail = "Email"
        static let Button1 = "firstLvl"
        static let Button2 = "secondLvl"
        static let Button3 = "thirdLvl"
        static let hide1 = "hide1"
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            }, error:{ (validationError) -> Void in
                
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 1.0
                
                self.showToastMessage(validationError.errorMessage)
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLeftButton(){
        let tools = UIToolbar()
        tools.frame = CGRectMake(0, 0, 95, 44)
        tools.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        tools.backgroundColor = UIColor.clearColor()
        tools.clipsToBounds = true;
        tools.translucent = true;
        
        let image1 = UIImage(named: "MenuIcon")! .imageWithRenderingMode(.AlwaysOriginal)
        let image2 = UIImage(named: "back")! .imageWithRenderingMode(.AlwaysOriginal)
        
        let menuButton = UIBarButtonItem(image: image1, style: .Plain, target: self, action: "menuTapped:")
        menuButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        
        let backButton = UIBarButtonItem(image: image2, style: .Plain, target: self, action: "backButtonPressed:")
        backButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        
        
        let buttons:[UIBarButtonItem] = [menuButton, backButton];
        tools.setItems(buttons, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tools)
    }
    
    func setupMenuButton(){
        
        let tools = UIToolbar()
        tools.frame = CGRectMake(0, 0, 95, 44)
        tools.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        tools.backgroundColor = UIColor.clearColor()
        tools.clipsToBounds = true;
        tools.translucent = true;
        
        let image1 = UIImage(named: "MenuIcon")! .imageWithRenderingMode(.AlwaysOriginal)
        
        let menuButton = UIBarButtonItem(image: image1, style: .Plain, target: self, action: "menuTapped:")
        menuButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        
        let buttons:[UIBarButtonItem] = [menuButton];
        tools.setItems(buttons, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tools)
        
    }
    
    func menuTapped(sender: UIBarButtonItem){
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    func backButtonPressed(sender: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func validateForm() {
       /* let array = formValidationErrors()
        
        if array.count != 0{
            
            isValidate = false
            
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                let cell = self.tableView.cellForRowAtIndexPath(index) as! XLFormTextFieldCell
                
                let msg = String(format: "%@ %@", validationStatus.rowDescriptor!.tag!, validationStatus.msg)
                
                if validationStatus.msg == " can't be empty"{
                    
                    let textFieldAttrib = NSAttributedString.init(string: msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                    cell.textField?.attributedPlaceholder = textFieldAttrib
                    
                }else{
                    
                    cell.backgroundColor = .orangeColor()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.backgroundColor = UIColor(patternImage: UIImage(named: "txtField")!)
                    })
                    
                    self.showToastMessage(validationStatus.msg)
                    
                }
                self.animateCell(cell)
            }
        }else{
            isValidate = true
        }*/
        
        let array = formValidationErrors()
        
        if array.count != 0{
            
            isValidate = false
            for errorItem in array {
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                if let rowDescriptor = validationStatus.rowDescriptor, let indexPath = form.indexPathOfFormRow(rowDescriptor), let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    self.showToastMessage(validationStatus.msg)
                    self.animateCell(cell)
                }
            }
        }else{
            isValidate = true
        }

    }

    func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }
    
    func showHud(){
        HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        HUD.mode = MBProgressHUDMode.Indeterminate
        HUD.labelText = "Loading"
    }
    
    func hideHud(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func showToastMessage(message:String){
        HUD = MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        HUD.yOffset = 0
        HUD.mode = MBProgressHUDMode.Text
        HUD.detailsLabelText = message
        HUD.removeFromSuperViewOnHide = true
        HUD.hide(true, afterDelay: 3)
    }
    
    func formatDate(date:NSDate) -> String{
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.stringFromDate(date)
        
    }
    
    // MARK: ValidationDelegate Methods
    
    func validationSuccessful() {
        
        
    }
    func validationFailed(errors:[UITextField:ValidationError]) {
        //print(errors)
        
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
