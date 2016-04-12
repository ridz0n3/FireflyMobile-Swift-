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
import SCLAlertView

var isValidate: Bool = false

class BaseXLFormViewController: XLFormViewController, MBProgressHUDDelegate, ValidationDelegate {
    
    var alertView = SCLAlertView()
    //var alertViewResponder = nil
    var HUD : MBProgressHUD = MBProgressHUD()
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            
            }, error:{ (validationError) -> Void in
                
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 1.0
                
                showErrorMessage(validationError.errorMessage)
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
        
        let menuButton = UIBarButtonItem(image: image1, style: .Plain, target: self, action: #selector(BaseXLFormViewController.menuTapped(_:)))
        menuButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        
        let backButton = UIBarButtonItem(image: image2, style: .Plain, target: self, action: #selector(BaseXLFormViewController.backButtonPressed(_:)))
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
        
        let menuButton = UIBarButtonItem(image: image1, style: .Plain, target: self, action: #selector(BaseXLFormViewController.menuTapped(_:)))
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
        let array = formValidationErrors()
        
        if array.count != 0{
            isValidate = false
            //AnalyticsManager.sharedInstance.logScreen(GAConstants.manageFlightErrorScreen)
            var i = 0
            var message = String()
            
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let errorTag = validationStatus.rowDescriptor!.tag!.componentsSeparatedByString("(")
                let empty = validationStatus.msg.componentsSeparatedByString("*")
                
                if empty.count == 1{
                    
                    message += "\(validationStatus.msg),\n"
                    i += 1
                    
                }else{
                    if errorTag[0] == Tags.ValidationPurpose
                        || errorTag[0] == Tags.ValidationState
                        || errorTag[0] == Tags.ValidationCardType
                        || errorTag[0] == Tags.ValidationCardExpiredDate
                        || errorTag[0] == Tags.ValidationArriving
                        || errorTag[0] == Tags.ValidationDeparting
                        || errorTag[0] == Tags.ValidationTitle
                        || errorTag[0] == Tags.ValidationCountry
                        || errorTag[0] == Tags.ValidationTravelDoc
                        || errorTag[0] == Tags.ValidationTravelWith
                        || errorTag[0] == Tags.ValidationGender{
                            
                            let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                            
                            if self.tableView.cellForRowAtIndexPath(index) != nil{
                                let cell = self.tableView.cellForRowAtIndexPath(index) as! CustomFloatLabelCell
                                
                                let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                                cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                                
                                animateCell(cell)
                            }
                            
                            
                    }else if errorTag[0] == Tags.ValidationDate || errorTag[0] == Tags.ValidationExpiredDate{
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! CustomFloatLabelCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                    }else{
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! CustomFloatLabelCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                    }
                }
            }
            
            if i != 0{
                showErrorMessage(message)
            }else{
                showErrorMessage("Please fill all fields")
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
    
    
    
    func formatDate(date:NSDate) -> String{
        
        let formater = NSDateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        return formater.stringFromDate(date)
        
    }
    
    func stringToDate(date:String) -> NSDate{
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.dateFromString(date)!
        
    }
    
    // MARK: ValidationDelegate Methods
    
    func validationSuccessful() {
        
        
    }
    func validationFailed(errors:[UITextField:ValidationError]) {
        //print(errors)
        
    }
    
    func getTitleCode(titleName:String, titleArr:[Dictionary<String, AnyObject>])->String{
        var titleCode = String()
        for titleData in titleArr{
            if titleData["title_name"] as! String == titleName{
                titleCode = titleData["title_code"] as! String
            }
        }
        return titleCode
    }
    
    func getCountryCode(countryName:String, countryArr:[Dictionary<String, AnyObject>])->String{
        var countryCode = String()
        for countryData in countryArr{
            if countryData["country_name"] as! String == countryName{
                countryCode = countryData["country_code"] as! String
            }
        }
        return countryCode
    }
    
    func getStateCode(stateName:String, stateArr:[Dictionary<String, AnyObject>]
        )->String{
            var stateCode = String()
            for stateData in stateArr{
                    if stateData["state_name"] as! String == stateName{
                        stateCode = stateData["state_code"] as! String
                    }
                }
            if stateCode == ""{
                stateCode = "OT"
            }
            
            return stateCode
    }
    
    func getTravelDocCode(docName:String, docArr:[Dictionary<String, AnyObject>])->String{
        var docCode = String()
        for docData in docArr{
            if docData["doc_name"] as! String == docName{
                docCode = docData["doc_code"] as! String
            }
        }
        return docCode
    }
    
    func getTravelWithCode(travelName:String, travelArr:[Dictionary<String, AnyObject>])->String{
        var travelCode = String()
        for travelData in travelArr {
            if travelData["passenger_name"] as! String == travelName{
                travelCode = travelData["passenger_code"] as! String
            }
        }
        return travelCode
    }
    
    func getGenderCode(genderName:String, genderArr:[Dictionary<String, AnyObject>])->String{
        var genderCode = String()
        for genderData in genderArr{
            if genderData["gender_name"] as! String == genderName{
                genderCode = genderData["gender_code"] as! String
            }
        }
        return genderCode
    }
    
    func getStationCode(stationName:String, locArr:[NSDictionary], direction : String)->String{
        var stationCode = String()
        for stationData in locArr{
            
            if direction == "Departing"{
                if stationData["location"] as! String == stationName{
                    stationCode = stationData["location_code"] as! String
                }
            }else{
                if stationData["travel_location"] as! String == stationName{
                    stationCode = stationData["travel_location_code"] as! String
                }
            }
            
        }
        return stationCode
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
