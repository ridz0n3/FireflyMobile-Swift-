//
//  ViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
//import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = "Pattern~\(self.title!)"
        
        // The UA-XXXXX-Y tracker ID is loaded automatically from the
        // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
        // If you're copying this to an app just using Analytics, you'll
        // need to configure your tracking ID here.
        // [START screen_view_hit_swift]
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        // [END screen_view_hit_swift]
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /*let parameters = [
            "username": "zhariffadam00@me-tech.com.my",
            "password": "P@$$w0rd",
        ]
        
        Alamofire.request(.POST, "http://fyapidev.me-tech.com.my/Login", parameters: parameters).responseJSON {
            
            response in
        
            if let JSON = response.result.value {
                print("JSON: \(JSON["message"]!)")
            }
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

