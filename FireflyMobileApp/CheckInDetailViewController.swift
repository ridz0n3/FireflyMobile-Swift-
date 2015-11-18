//
//  CheckInDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class CheckInDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var flightDetailTableView: UITableView!
    @IBOutlet weak var flightDateLbl: UILabel!
    @IBOutlet weak var flightNumberLbl: UILabel!
    @IBOutlet weak var stationCodeLbl: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    
    @IBOutlet weak var flightDetailView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        self.flightDetailTableView.tableHeaderView = self.flightDetailView
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
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.flightDetailTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "MobileCheckIn", bundle: nil)
        let checkInTermVC = storyboard.instantiateViewControllerWithIdentifier("CheckInTermVC") as! CheckInTermViewController
        self.navigationController!.pushViewController(checkInTermVC, animated: true)
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
