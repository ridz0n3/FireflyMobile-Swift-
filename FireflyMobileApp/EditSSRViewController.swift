//
//  EditSSRViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 4/14/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import XLForm
import SwiftyJSON

class EditSSRViewController: BaseXLFormViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        continueBtn.layer.cornerRadius = 10
        initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "")
        section = XLFormSectionDescriptor()
        section = XLFormSectionDescriptor.formSectionWithTitle("SPECIAL MEALS REQUEST")
        form.addFormSection(section)
        
        //first name
        row = XLFormRowDescriptor(tag: Tags.ValidationFirstName, rowType: XLFormRowDescriptorTypeFloatLabeled, title:"First Name/Given Name:*")
        //row.addValidator(XLFormRegexValidator(msg: "First name is invalid.", andRegexString: "^[a-zA-Z ]{0,}$"))
        row.required = true
        section.addFormRow(row)
        self.form = form
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        /*if flightType == "MH"{
            
            if meals.count == 2{
                if section == 1 || section == 2{
                    return UITableViewAutomaticDimension
                    
                }else{
                    return 35
                }
                
            }else{
                if section == 1{
                    return UITableViewAutomaticDimension
                    
                }else{
                    return 35
                }
            }
            
        }else{*/
            return 35
        //}
        
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("PassengerHeader", owner: self, options: nil)[0] as! PassengerHeaderView
        
        let index = UInt(section)
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title
        sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        
        sectionView.sectionLbl.textColor = UIColor.whiteColor()
        sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        /*
        if flightType == "MH"{
            
            if meals.count == 2{
                if index == 1 || index == 2{
                    sectionView.views.backgroundColor = UIColor.whiteColor()
                    sectionView.sectionLbl.textColor = UIColor.blackColor()
                    sectionView.sectionLbl.font = UIFont.boldSystemFontOfSize(12.0)
                    sectionView.sectionLbl.textAlignment = NSTextAlignment.Left
                    
                }else{
                    sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                    sectionView.sectionLbl.textColor = UIColor.whiteColor()
                    sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
                }
                
            }else{
                if index == 1{
                    sectionView.views.backgroundColor = UIColor.whiteColor()
                    sectionView.sectionLbl.textColor = UIColor.blackColor()
                    sectionView.sectionLbl.font = UIFont.boldSystemFontOfSize(12.0)
                    sectionView.sectionLbl.textAlignment = NSTextAlignment.Left
                    
                }else{
                    sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                    sectionView.sectionLbl.textColor = UIColor.whiteColor()
                    sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
                }
            }
            
        }else{
            sectionView.views.backgroundColor = UIColor(red: 240.0/255.0, green: 109.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            
            sectionView.sectionLbl.textColor = UIColor.whiteColor()
            sectionView.sectionLbl.textAlignment = NSTextAlignment.Center
        }*/
        
        
        return sectionView
        
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
    }
}
