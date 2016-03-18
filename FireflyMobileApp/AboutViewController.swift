//
//  AboutViewController.swift
//  FireflyMobileApp
//
//  Created by Nazri Hussein on 3/2/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class AboutViewController: BaseViewController {

    @IBOutlet weak var aboutLbl: UITextView!
    @IBOutlet weak var lineView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        lineView.layer.borderWidth = 1
        
        showLoading(self)
        //showHud("open")
        
        FireFlyProvider.request(.GetAbout) { (result) -> () in
            switch result {
            case .Success(let successResult):
                do {
                    //showHud("close")
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        self.aboutLbl.attributedText = json["data"].string?.html2String
                        
                    }else if json["status"] == "error"{
                        //showErrorMessage(json["message"].string!)
                        showErrorMessage(json["message"].string!)
                        
                    }
                    hideLoading(self)
                }
                catch {
                    
                }
            case .Failure(let failureResult):
                hideLoading(self)
                showErrorMessage(failureResult.nsError.localizedDescription)
                //showHud("close")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
