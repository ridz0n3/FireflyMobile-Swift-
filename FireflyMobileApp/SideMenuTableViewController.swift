//
//  SideMenuTableViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    var menuSections:[String] = ["Home", "Login", "Register", "About", "FAQ", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuSections.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SideMenuTableViewCell
        
        // This is how you change the background color
        cell.selectionStyle = .Default
        let bgColorView = UIView.init()
        bgColorView.backgroundColor = UIColor(red: 240/255, green: 109/255, blue: 34/255, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        
        cell.menuLbl.text = menuSections[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, 50))
        let label = UILabel.init(frame:CGRectMake(15, 0, tableView.frame.size.width, 50))
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28.0)
        label.tintColor = UIColor.whiteColor()
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.clearColor()
        
        let string = "FIREFLY" as String
        
        label.text = string
        view.addSubview(label)
        view.backgroundColor = UIColor.darkGrayColor()
        
        return view
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let navigationController = self.menuContainerViewController.centerViewController as! UINavigationController
        
        var controllers:[UIViewController] = [UIViewController]()
        
        if (indexPath.row == 0) {
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let homeVC = storyboard.instantiateViewControllerWithIdentifier("HomeVC")
            controllers.append(homeVC)
            
        }else if (indexPath.row == 1) {
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC")
            controllers.append(loginVC)
            
        }else if (indexPath.row == 2) {
            
            let storyboard = UIStoryboard(name: "Register", bundle: nil)
            let registerVC = storyboard.instantiateViewControllerWithIdentifier("RegisterVC")
            controllers.append(registerVC)
            
        }else if (indexPath.row == 3) {
            
        }else if (indexPath.row == 4) {
            
        }else{
            
        }
        
        if (controllers.count != 0){
            navigationController.viewControllers = controllers 
            self.menuContainerViewController.setMenuState(MFSideMenuStateClosed, completion: nil)
        }

        
        //self.menuContainerViewController.setMenuState(, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
