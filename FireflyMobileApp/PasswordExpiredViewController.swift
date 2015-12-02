//
//  PasswordExpiredViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/27/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class PasswordExpiredViewController: BaseViewController {

    @IBOutlet weak var PasswordExpiredTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 3 {
            
            let cell = self.PasswordExpiredTableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! CustomPasswordExpiredTableViewCell
            
            cell.titleLbl.text = "UserEmail:*"
            return cell;
            
        }else{
            
            let cell = self.PasswordExpiredTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomPasswordExpiredTableViewCell
            
            if indexPath.row == 0 {
                cell.titleLbl.text = "Current Password:*"
            }else if indexPath.row == 1 {
                cell.titleLbl.text = "New Password:*"
            }else{
                cell.titleLbl.text = "Confirm Password:*"
            }
            
            return cell;
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
