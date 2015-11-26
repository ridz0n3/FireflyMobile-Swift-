//
//  HomeViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var homeMenuTableView: UITableView!
    
    var menuTitle:[String] = ["","BOOK FLIGHT", "MANAGE FLIGHT", "MOBILE CHECK-IN", "BOARDING PASS",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuButton()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "reloadHome", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            if self.view.frame.size.height < self.view.frame.size.width {
                return self.view.frame.size.width - 236
            }else{
                return self.view.frame.size.height - 236
            }
            
        }
        else if indexPath.row == 5 {
            
            return 36
            
        }else {
        
            return 50;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath) as! CustomHomeMenuTableViewCell
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if (defaults.objectForKey("banner") != nil){
                let url = NSURL(string: defaults.objectForKey("banner") as! String)!
                let data = NSData(contentsOfURL: url)
                
                if (data != nil){
                    cell.banner.image = UIImage(data: data!)
                }
                
            }
            
            return cell
        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier("SocialCell", forIndexPath: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomHomeMenuTableViewCell
            
            let replaced = menuTitle[indexPath.row].stringByReplacingOccurrencesOfString(" ", withString: "")
            
            cell.bgView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
            cell.menuLbl?.text = menuTitle[indexPath.row]
            cell.menuIcon.image = UIImage(named: replaced)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 1{
            
            let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
            let bookFlightVC = storyboard.instantiateViewControllerWithIdentifier("BookFlightVC") as! SearchFlightViewController
            self.navigationController!.pushViewController(bookFlightVC, animated: true)
            
        }else if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
            let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightVC") as! ManageFlightViewController
            self.navigationController!.pushViewController(manageFlightVC, animated: true)
        }else if indexPath.row == 3{
            let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
            let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("CheckInVC") as! CheckInViewController
            self.navigationController!.pushViewController(manageFlightVC, animated: true)
        }else if indexPath.row == 4{
            let storyboard = UIStoryboard(name: "BoardingPass", bundle: nil)
            let boardingPassVC = storyboard.instantiateViewControllerWithIdentifier("BoardingPassVC") as! BoardingPassViewController
            self.navigationController!.pushViewController(boardingPassVC, animated: true)
        }
    }
    
    func refreshTable(sender: NSNotification){
        self.homeMenuTableView.reloadData()
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
