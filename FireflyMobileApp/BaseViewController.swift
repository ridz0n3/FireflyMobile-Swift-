//
//  BaseViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftValidator
import SCLAlertView

class BaseViewController: UIViewController, MBProgressHUDDelegate, ValidationDelegate {
    
    var alertView = SCLAlertView()
    @IBOutlet weak var borderView: UIView!
    var HUD : MBProgressHUD = MBProgressHUD()
    var location = [NSDictionary]()
    var travel = [NSDictionary]()
    var pickerRow = [String]()
    var pickerTravel = [String]()
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            validationRule.textField.layer.borderColor = UIColor.greenColor().CGColor
            validationRule.textField.layer.borderWidth = 0.5
            
            }, error:{ (validationError) -> Void in
                print("error")
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 1.0
        })
        //self.borderView.layer.borderColor = UIColor.grayColor().CGColor
        //self.borderView.layer.borderWidth = 1
        
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
    
    func actionPickerCancelled(sender:AnyObject){
        //do nothing
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
    
    //MARK: - Get flight
    
    func getDepartureAirport(module : String){
        
        if (defaults.objectForKey("flight") != nil){
            
            let flight = defaults.objectForKey("flight") as! [Dictionary<String,AnyObject>]
            
            var first = flight[0]["location_code"]
            location.append(flight[0])
            pickerRow.append("\(flight[0]["location"] as! String) (\(flight[0]["location_code"] as! String))")
            for loc in flight{
                
                if loc["status"] as! String == "Y"{
                    if loc["location_code"] as! String != first as! String{
                        location.append(loc)
                        pickerRow.append("\(loc["location"] as! String) (\(loc["location_code"] as! String))")
                        first = loc["location_code"]
                    }
                }
            }
            
        }
        
    }
    
    func getArrivalAirport(departureAirport: String, module : String){
        
        if (defaults.objectForKey("flight") != nil){
            let flight = defaults.objectForKey("flight") as! [Dictionary<String,AnyObject>]
            let first = departureAirport
            
            for loc in flight{
                if loc["status"] as! String == "Y"{
                    if loc["location_code"] as! String == first{
                        travel.append(loc)
                        pickerTravel.append("\(loc["travel_location"] as! String) (\(loc["travel_location_code"] as! String))")
                    }
                }
            }
        }
        
    }
    
    func formatDate(date:NSDate) -> String{
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.stringFromDate(date)
        
    }
    
    func stringToDate(date:String) -> NSDate{
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.dateFromString(date)!
        
    }
    
    // MARK: ValidationDelegate Methods
    
    func validationSuccessful() {
        print("Validation Success!")
        let alert = UIAlertController(title: "Success", message: "You are validated!", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        print("Validation FAILED!")
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
