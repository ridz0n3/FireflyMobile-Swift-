//
//  BaseViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, MBProgressHUDDelegate {

    @IBOutlet weak var borderView: UIView!
    var HUD : MBProgressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.borderView.layer.borderColor = UIColor.grayColor().CGColor
        //self.borderView.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLeftButton(){
        let tools = UIToolbar()
        tools.frame = CGRectMake(0, 0, 95, 44)
        tools.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        tools.backgroundColor = UIColor.clearColor()
        tools.clipsToBounds = true;
        tools.translucent = true;
        
        let image1 = UIImage(named: "MenuIcon")! .imageWithRenderingMode(.AlwaysOriginal)
        let image2 = UIImage(named: "back")! .imageWithRenderingMode(.AlwaysOriginal)
        
        let menuButton = UIBarButtonItem(image: image1, style: .Plain, target: self, action: "menuTapped:")
        menuButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        
        let backButton = UIBarButtonItem(image: image2, style: .Plain, target: self, action: "backButtonPressed:")
        backButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        
        
        let buttons:[UIBarButtonItem] = [menuButton, backButton];
        tools.setItems(buttons, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tools)
    }

    func setupMenuButton(){
        
        let tools = UIToolbar()
        tools.frame = CGRectMake(0, 0, 95, 44)
        tools.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
        tools.backgroundColor = UIColor.clearColor()
        tools.clipsToBounds = true;
        tools.translucent = true;
        
        let image1 = UIImage(named: "MenuIcon")! .imageWithRenderingMode(.AlwaysOriginal)
        
        let menuButton = UIBarButtonItem(image: image1, style: .Plain, target: self, action: "menuTapped:")
        menuButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0)
        
        let buttons:[UIBarButtonItem] = [menuButton];
        tools.setItems(buttons, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tools)
        
    }
    
    func menuTapped(sender: UIBarButtonItem){
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    func backButtonPressed(sender: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showHud(){
        HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        HUD.mode = MBProgressHUDMode.Indeterminate
        HUD.labelText = "Loading"
    }
    
    func hideHud(){
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
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
