//
//  EditPassengerViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class EditPassengerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var editPassengerTableView: UITableView!
    
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
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 3{
            let cell = self.editPassengerTableView.dequeueReusableCellWithIdentifier("dateCell", forIndexPath: indexPath) as! CustomPersonalDetailTableViewCell
            
            cell.titleLbl.text = "Date of Birth:*"
            
            return cell
        }else{
            let cell = self.editPassengerTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomPersonalDetailTableViewCell
            
            if indexPath.row == 0 {
                cell.titleLbl.text = "Title:*"
            }else if indexPath.row == 1 {
                cell.titleLbl.text = "First Name:*"
            }else if indexPath.row == 2 {
                cell.titleLbl.text = "Last Name:*"
            }else{
                cell.titleLbl.text = "Nationality:*"
            }
            
            return cell
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
