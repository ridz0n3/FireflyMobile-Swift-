//
//  NewUpdateViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/16/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class NewUpdateViewController: BaseViewController {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var borderViews: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLbl.text = "There is a newer version available for download! Please update the app by visiting the Apple Store."
        updateBtn.layer.cornerRadius = 10
        updateBtn.layer.borderColor = UIColor.orange.cgColor
        updateBtn.layer.borderWidth = 1
        borderViews.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateBtnPressed(sender: AnyObject) {
        UIApplication.shared.openURL(URL(string : "https://itunes.apple.com/us/app/firefly-mobile/id506588979?mt=8")!)
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
