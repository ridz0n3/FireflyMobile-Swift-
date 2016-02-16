//
//  CommonSearchDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/15/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class CommonSearchDetailViewController: BaseXLFormViewController {

    @IBOutlet weak var continueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        continueBtn.layer.cornerRadius = 10.0
        
        getDepartureAirport()
        initializeForm()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshArrivingCode:", name: "refreshArrivingCode", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshArrivingCode(notif : NSNotification){
        travel = [NSDictionary]()
        getArrivalAirport(notif.userInfo!["departStationCode"] as! String)
        self.form.removeFormRowWithTag(Tags.ValidationArriving)
        
        var row : XLFormRowDescriptor
        
        // Arriving
        row = XLFormRowDescriptor(tag: Tags.ValidationArriving, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Arriving:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for arrivingStation in travel{
            tempArray.append(XLFormOptionsObject(value: arrivingStation["location_code"], displayText: arrivingStation["travel_location"] as! String))
        }
        row.selectorOptions = tempArray
        row.required = true
        self.form.addFormRow(row, afterRowTag: Tags.ValidationDeparting)
        
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
        row.value = "y4pcsf"
        section.addFormRow(row)
        
        
        // Departing
        row = XLFormRowDescriptor(tag: Tags.ValidationDeparting, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Departing:*")
        
        var tempArray:[AnyObject] = [AnyObject]()
        for departureStation in location{
            tempArray.append(XLFormOptionsObject(value: departureStation["location_code"], displayText: departureStation["location"] as! String))
        }
        row.selectorOptions = tempArray
        row.required = true
        section.addFormRow(row)
        
        // Arriving
        row = XLFormRowDescriptor(tag: Tags.ValidationArriving, rowType:XLFormRowDescriptorTypeFloatLabeledPicker, title:"Arriving:*")
        row.disabled = NSNumber(bool: true)
        row.required = true
        section.addFormRow(row)
        
        self.form = form
        
    }

    override func validateForm() {
        let array = formValidationErrors()
        
        if array.count != 0{
            isValidate = false
            
            for errorItem in array {
                
                let error = errorItem as! NSError
                let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
                
                let errorTag = validationStatus.rowDescriptor!.tag!
                
                if errorTag == Tags.ValidationArriving ||
                    errorTag == Tags.ValidationDeparting {
                        let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                        
                        if self.tableView.cellForRowAtIndexPath(index) != nil{
                            let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledPickerCell
                            
                            let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                            cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                            
                            animateCell(cell)
                        }
                        
                        
                }else {
                    let index = self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)! as NSIndexPath
                    
                    if self.tableView.cellForRowAtIndexPath(index) != nil{
                        let cell = self.tableView.cellForRowAtIndexPath(index) as! FloatLabeledTextFieldCell
                        
                        let textFieldAttrib = NSAttributedString.init(string: validationStatus.msg, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
                        cell.floatLabeledTextField.attributedPlaceholder = textFieldAttrib
                        
                        animateCell(cell)
                    }
                }
                //showToastMessage("Please fill all fields")
                
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
