//
//  PaymentViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/17/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var paymentTableView: UITableView!
    
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
        return 8
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 || indexPath.row == 5 {
            return 40;
        }else if indexPath.row == 4 {
            return 44;
        }else if indexPath.row == 6 {
            return 23;
        }else if indexPath.row == 7 {
            return 336;
        }else{
            return 80;
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("priceSumCell", forIndexPath: indexPath) as! CustomPaymentTableViewCell
            
            return cell
        }else if (indexPath.row == 1) {
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! CustomPaymentTableViewCell
            
            return cell
        }else if (indexPath.row == 2) {
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! CustomPaymentTableViewCell
            
            return cell
        }else if (indexPath.row == 3) {
            
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! CustomPaymentTableViewCell
            cell.detailLbl.hidden = true
            cell.taxPriceLbl.text = "Taxes"
            cell.guestLbl.text = "Insurance"
            cell.flightLbl.text = "Service and Fee"
            return cell
            
        }else if (indexPath.row == 4) {
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("totalCell", forIndexPath: indexPath) as! CustomPaymentTableViewCell
            return cell
        }else if (indexPath.row == 5) {
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("priceSumCell", forIndexPath: indexPath) as! CustomPaymentTableViewCell
            cell.headerTitle.text = "PAYMENT"
            return cell
        }else if (indexPath.row == 6){
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("sessionTimeoutCell", forIndexPath: indexPath) as! CustomPaymentTableViewCell
            
            return cell
        }else{
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("cardTypeCell", forIndexPath: indexPath) as! CustomPaymentTableViewCell
            
            return cell
        }
    }

    @IBAction func continueButtonPressed(sender: AnyObject) {
        
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
