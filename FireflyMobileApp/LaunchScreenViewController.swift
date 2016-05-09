//
//  LaunchScreenViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 3/16/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import MBProgressHUD

class LaunchScreenViewController: UIViewController, MBProgressHUDDelegate {

    @IBOutlet weak var loading: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //loadingNotification.color = UIColor.clearColor()
        
        let loadingGif = UIImage.gifWithName("preloader")
        let imageView = UIImageView(image: loadingGif)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        loading.addSubview(imageView)
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
