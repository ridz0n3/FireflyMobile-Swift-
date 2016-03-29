//
//  InsuranceViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/28/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class InsuranceViewController: UIViewController {

    @IBOutlet weak var msg: UITextView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var noThankBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    var vc = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgView.layer.cornerRadius = 10
        bgView.layer.borderColor = UIColor.blackColor().CGColor
        bgView.layer.borderWidth = 1
        
        noThankBtn.layer.cornerRadius = 10
        noThankBtn.layer.borderColor = UIColor.orangeColor().CGColor
        noThankBtn.layer.borderWidth = 1
        
        yesBtn.layer.cornerRadius = 10
        yesBtn.layer.borderColor = UIColor.orangeColor().CGColor
        yesBtn.layer.borderWidth = 1
        
        let str = "<b>We noticed that you have opt-out from the Firefly Travel Protection plan. For your peace of mind, we strongly recommend you obtain appropriate protection for your travelling needs</b><br><br>Firefly Travel Protection protects you against unexpected events during your trip. From unfortunate accidents to lost travel documents, Firefly Travel Protection will take care of you (details)."
        
        msg.attributedText = str.html2String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func noThankBtnPressed(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("refreshInsurance", object: nil)
        vc.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func yesBtnPressed(sender: AnyObject) {
        
        vc.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        
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
