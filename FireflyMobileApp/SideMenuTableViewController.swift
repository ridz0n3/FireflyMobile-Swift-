//
//  SideMenuTableViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit


class SideMenuTableViewController: UITableViewController {

    @IBOutlet var sideMenuTableView: UITableView!
    var menuSections:[String] = ["Home", "Update Information", "Login", "Register", "About", "FAQ", "Logout"]
    var hideRow : Bool = false
    var selectedMenuItem : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshSideMenu:", name: "reloadSideMenu", object: nil)
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menuSections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        cell!.textLabel?.text = menuSections[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 1 && hideRow == false) || (indexPath.row == 6 && hideRow == false) || (indexPath.row == 2 && hideRow == true) || (indexPath.row == 3 && hideRow == true){
            return 0.0
        }else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeVC")
            break
        case 1:
            let storyboard = UIStoryboard(name: "UpdateInformation", bundle: nil)
            destViewController = storyboard.instantiateViewControllerWithIdentifier("UpdateInformationVC")
            
            break
        case 2:
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            destViewController = storyboard.instantiateViewControllerWithIdentifier("LoginVC")
            break
        case 3:
            let storyboard = UIStoryboard(name: "Register", bundle: nil)
            destViewController = storyboard.instantiateViewControllerWithIdentifier("RegisterVC")
            break
        /*case 4:
            let storyboard = UIStoryboard(name: "About", bundle: nil)
            destViewController = storyboard.instantiateViewControllerWithIdentifier("AboutVC")
            break
        case 5:
            let storyboard = UIStoryboard(name: "FAQ", bundle: nil)
            destViewController = storyboard.instantiateViewControllerWithIdentifier("FAQVC")
            break*/
        default:
            let storyboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            destViewController = storyboard.instantiateViewControllerWithIdentifier("HomeVC")
            break
        }
       sideMenuController()?.setContentViewController(destViewController)
    }
    
    func refreshSideMenu(notif:NSNotificationCenter){
        hideRow = true
        self.sideMenuTableView.reloadData()
    }
    

}
