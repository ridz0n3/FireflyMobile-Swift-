//
//  LeftSideMenuViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 4/25/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var leftMenuTableView: UITableView!
    var menuSections:[String] = ["LabelMenuHome".localized, "LabelMenuUpdateInformation".localized, "LabelMenuLogin".localized, "LabelMenuRegister".localized, "LabelMenuAbout".localized, "LabelMenuFAQ".localized, "LabelMenuLogout".localized]
    
    var menuIcon:[String] = ["homeIcon", "profileIcon", "loginIcon", "registerIcon", "aboutIcon", "faqIcon", "logoutIcon"]
    
    var hideRow : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(LeftSideMenuViewController.refreshSideMenu(_:)), name: "reloadSideMenu", object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LeftSideMenuViewController.logoutSession(_:)), name: "logout", object: nil)
        
        if try! LoginManager.sharedInstance.isLogin(){
            hideRow = true
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logoutSession(sender : NSNotificationCenter){
        
        self.hideRow = false
        self.leftMenuTableView.reloadData()
        
    }
    
    func refreshSideMenu(notif:NSNotificationCenter){
        hideRow = true
        self.leftMenuTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 1 && hideRow == false) || (indexPath.row == 6 && hideRow == false) || (indexPath.row == 2 && hideRow == true) || (indexPath.row == 3 && hideRow == true){
            return 0.0
        }else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = leftMenuTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SideMenuTableViewCell
        
        // This is how you change the background color
        cell.selectionStyle = .Default
        let bgColorView = UIView.init()
        bgColorView.backgroundColor = UIColor(red: 240/255, green: 109/255, blue: 34/255, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        
        cell.menuLbl.text = menuSections[indexPath.row]
        cell.menuIcon.image = UIImage(named: menuIcon[indexPath.row])
        
        return cell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
        let label = UILabel.init(frame:CGRectMake(15, 0, tableView.frame.size.width, 50))
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28.0)
        label.tintColor = UIColor.whiteColor()
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.clearColor()
        
        
        
        if hideRow == true{
            let userInfo = defaults.object(forKey: "userInfo") as! NSMutableDictionary
            let greetMsg = String(format: "Hi, %@", userInfo["first_name"] as! String)
            
            label.text = greetMsg
        }else{
            label.text = "FIREFLY"
        }
        
        view.addSubview(label)
        view.backgroundColor = UIColor.darkGrayColor()
        
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let navigationController : UIViewController!
        
        if (indexPath.row == 0) {
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let homeVC = storyboard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
            navigationController = UINavigationController(rootViewController: homeVC)
            
        }else if (indexPath.row == 1) {
            let storyboard = UIStoryboard(name: "UpdateInformation", bundle: nil)
            let updateVC = storyboard.instantiateViewControllerWithIdentifier("UpdateInfoVC") as! UpdateInformationViewController
            navigationController = UINavigationController(rootViewController: updateVC)
            
        }else if (indexPath.row == 2) {
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
            navigationController = UINavigationController(rootViewController: loginVC)
            
        }else if (indexPath.row == 3) {
            
            let storyboard = UIStoryboard(name: "Register", bundle: nil)
            let registerVC = storyboard.instantiateViewControllerWithIdentifier("RegisterVC") as! RegisterPersonalInfoViewController
            navigationController = UINavigationController(rootViewController: registerVC)
            
        }else if (indexPath.row == 4) {
            
            let storyboard = UIStoryboard(name: "About", bundle: nil)
            let aboutVC = storyboard.instantiateViewControllerWithIdentifier("AboutVC") as! AboutViewController
            navigationController = UINavigationController(rootViewController: aboutVC)
            
        }else if (indexPath.row == 5) {
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let faqVC = storyboard.instantiateViewControllerWithIdentifier("FAQVC") as! FAQViewController
            navigationController = UINavigationController(rootViewController: faqVC)
            
        }else{
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let homeVC = storyboard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
            navigationController = UINavigationController(rootViewController: homeVC)
            LogoutManager.sharedInstance.logout()
        }
        
        self.slideMenuController()?.changeMainViewController(navigationController, close: true)

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
