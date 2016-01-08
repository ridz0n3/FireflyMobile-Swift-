//
//  ManageFlightMenuViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class ManageFlightMenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var manageFlightTableView: UITableView!
    var menuTitle:[String] = ["","CHANGE CONTACT", "EDIT PASSENGER", "CHANGE FLIGHT", "CHANGE SEAT","ADD PAYMENT", "SEND ITINERARY", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if self.view.frame.size.height < self.view.frame.size.width {
                return self.view.frame.size.width - 336;
            }else{
                return self.view.frame.size.height - 336;
            }
            
        }else if indexPath.row == 7 {
            
            return 36
            
        }else {
            return 50;
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath)
            return cell
        }else if indexPath.row == 7{
            let cell = tableView.dequeueReusableCellWithIdentifier("SocialCell", forIndexPath: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomManageFlightMenuTableViewCell
            
            cell.contentView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
            cell.menuTitle?.text = menuTitle[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
        
        if indexPath.row == 1{
            
            let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ChangeContactDetailVC") as! ChangeContactDetailViewController
            //let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("webviewVC") as! WebviewViewController
            self.navigationController!.pushViewController(manageFlightVC, animated: true)
        }else if indexPath.row == 2{
            let editPassengerVC = storyboard.instantiateViewControllerWithIdentifier("EditPassengerVC") as! EditPassengerViewController
            self.navigationController!.pushViewController(editPassengerVC, animated: true)
        }else if indexPath.row == 3{
            let changeFlightVC = storyboard.instantiateViewControllerWithIdentifier("ChangeFlightVC") as! ChangeFlightViewController
            self.navigationController!.pushViewController(changeFlightVC, animated: true)
        }else if indexPath.row == 4{
            let changeSeatVC = storyboard.instantiateViewControllerWithIdentifier("ChangeSeatVC") as! ChangeSeatViewController
            self.navigationController!.pushViewController(changeSeatVC, animated: true)
        }else if indexPath.row == 5{
            
        }else if indexPath.row == 6{
            let sendItineraryVC = storyboard.instantiateViewControllerWithIdentifier("SendItineraryVC") as! SendItineraryViewController
            self.navigationController!.pushViewController(sendItineraryVC, animated: true)
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
