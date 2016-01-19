//
//  ManageFlightViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON

class ManageFlightViewController: BaseXLFormViewController {

    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        continueBtn.layer.cornerRadius = 10.0
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
        let section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        /*//first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"First Name:*")
        row.required = true
        section.addFormRow(row)
        
        //last name
        row = XLFormRowDescriptor(tag: Tags.ValidationLastName, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Last Name:*")
        row.required = true
        section.addFormRow(row)*/
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmationNumber, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Confirmation Number"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = "xzn1tr"//"xz7i4b"
        section.addFormRow(row)
        
        // username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeText, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Contact Email"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        row.value = "Ridz@gmail.com"
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate{
            
            let pnr = self.formValues()[Tags.ValidationConfirmationNumber] as! String
            let username = self.formValues()[Tags.ValidationEmail] as! String
            showHud()
            FireFlyProvider.request(.RetrieveBooking("", pnr, username), completion: { (result) -> () in
                self.hideHud()
                switch result {
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if  json["status"].string == "success"{
                            self.showToastMessage(json["status"].string!)
                            defaults.setObject(json.object, forKey: "manageFlight")
                            defaults.synchronize()
                            
                            let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                            let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                            self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            
                        }else{
                            self.showToastMessage(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    print (successResult.data)
                case .Failure(let failureResult):
                    print (failureResult)
                }

            })

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
