//
//  ChangeFlightViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class ChangeFlightViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var changeFlightTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            
            let cell = self.changeFlightTableView.dequeueReusableCellWithIdentifier("departureCell", forIndexPath: indexPath) as! CustomChangeFlightTableViewCell
            return cell
            
        }else if (indexPath.row == 1) {
        
            let cell = self.changeFlightTableView.dequeueReusableCellWithIdentifier("arrivalCell", forIndexPath: indexPath) as! CustomChangeFlightTableViewCell
            return cell
            
        }else{
            
            let cell = self.changeFlightTableView.dequeueReusableCellWithIdentifier("dateCell", forIndexPath: indexPath) as! CustomChangeFlightTableViewCell
            return cell
            
        }

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let flightSection = NSBundle.mainBundle().loadNibNamed("FlightHeaderView", owner: self, options: nil)[0] as! ChangeFlightHeaderView
        
        flightSection.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        
        if (section == 1) {
            flightSection.wayLbl.text = "RETURN FLIGHT"
        }
        
        return flightSection
        
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
