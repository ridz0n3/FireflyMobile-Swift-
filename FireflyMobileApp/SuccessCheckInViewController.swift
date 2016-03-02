//
//  SuccessCheckInViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/15/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class SuccessCheckInViewController: BaseViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    var msg = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        border.layer.borderWidth = 1
        closeButton.layer.cornerRadius = 10
        messageTextView.attributedText = msg.html2String
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnPressed(sender: AnyObject) {
        
        for views in (self.navigationController?.viewControllers)!{
            if views.classForCoder == HomeViewController.classForCoder(){
                self.navigationController?.popToViewController(views, animated: true)
            }
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
