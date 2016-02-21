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
        setupLeftButton()
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
        
        
        //Confirmation Number
        row = XLFormRowDescriptor(tag: Tags.ValidationConfirmationNumber, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Confirmation Number:*")
        row.required = true
        //row.value = "y4pcsf"
        section.addFormRow(row)
        
        //Username
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail, rowType: XLFormRowDescriptorTypeFloatLabeledTextField, title:"Contact Email:*")
        row.required = true
        row.addValidator(XLFormValidator.emailValidator())
        //row.value = "y4pcsf"
        section.addFormRow(row)
        
        
        self.form = form
        
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate{
            
            let pnr = self.formValues()[Tags.ValidationConfirmationNumber] as! String
            let username = self.formValues()[Tags.ValidationEmail] as! String
            showHud("open")
            FireFlyProvider.request(.RetrieveBooking("", pnr, username, ""), completion: { (result) -> () in
                showHud("close")
                switch result {
                case .Success(let successResult):
                    do {
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if  json["status"].string == "success"{
                            
                            defaults.setObject(json.object, forKey: "manageFlight")
                            defaults.synchronize()
                            
                            let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                            let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                            self.navigationController!.pushViewController(manageFlightVC, animated: true)
                            
                        }else{
                            //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    
                case .Failure(let failureResult):
                    print (failureResult)
                }
                
            })
            
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
