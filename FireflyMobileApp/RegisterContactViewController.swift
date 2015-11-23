//
//  RegisterContactViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/18/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import XLForm

class RegisterContactViewController: BaseXLFormViewController {

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
        
        // Contact Information - Section
        section = XLFormSectionDescriptor()
        section.title = "Contact Information"
        form.addFormSection(section)
        
        // Mobile Number
        row = XLFormRowDescriptor(tag: Tags.ValidationMobileHome, rowType: XLFormRowDescriptorTypeNumber, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "*Mobile / Home"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Alternate
        row = XLFormRowDescriptor(tag: Tags.ValidationAlternate, rowType: XLFormRowDescriptorTypeNumber, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Alternate"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        section.addFormRow(row)
        
        // Fax
        row = XLFormRowDescriptor(tag: Tags.ValidationFax, rowType: XLFormRowDescriptorTypeNumber, title:"")
        row.cellConfigAtConfigure["textField.placeholder"] = "Fax"
        row.cellConfigAtConfigure["backgroundColor"] = UIColor(patternImage: UIImage(named: "txtField")!)
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = NSBundle.mainBundle().loadNibNamed("SectionView", owner: self, options: nil)[0] as! SectionView
        
        sectionView.frame = CGRectMake(0, 0,self.view.frame.size.width, 50)
        sectionView.backgroundColor = UIColor(patternImage: UIImage(named: "lines")!)
        
        let index = UInt(section)
        
        sectionView.sectionLbl.text = form.formSectionAtIndex(index)?.title
        
        return sectionView
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        validateForm()
        
        if isValidate {
            
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
