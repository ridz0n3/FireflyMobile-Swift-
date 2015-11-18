//
//  CheckInViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class CheckInViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var checkInTableView: UITableView!
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.checkInTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomPersonalDetailTableViewCell
        
        if indexPath.row == 0 {
            cell.titleLbl.text = "Confirmation Number:*"
        }else if indexPath.row == 1 {
            cell.titleLbl.text = "Departing:*"
        }else{
            cell.titleLbl.text = "Arriving:*"
        }
        
        return cell;
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
        let checkInDetailVC = storyboard.instantiateViewControllerWithIdentifier("CheckInDetailVC") as! CheckInDetailViewController
        self.navigationController!.pushViewController(checkInDetailVC, animated: true)
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
