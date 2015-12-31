//
//  PaymentSummaryViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/23/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class PaymentSummaryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var paymentTableView: UITableView!
    var flightDetail = NSArray()
    var priceDetail = NSArray()
    var totalPrice = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = NSUserDefaults.standardUserDefaults()
        let paymentDetail = defaults.objectForKey("itenerary") as! NSDictionary
        flightDetail = paymentDetail["flight_details"] as! NSArray
        priceDetail = paymentDetail["price_details"] as! NSArray
        totalPrice = paymentDetail["total_price"] as! String
        
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
        
        if section == 0{
            return flightDetail.count
        }else{
            return 1
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 137
        }else{
            return 80
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("FlightDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            cell.wayLbl.text = flightDetail[indexPath.row]["type"] as? String
            cell.dateLbl.text = flightDetail[indexPath.row]["date"] as? String
            cell.destinationLbl.text = flightDetail[indexPath.row]["station"] as? String
            cell.flightNumberLbl.text = flightDetail[indexPath.row]["flight_number"] as? String
            cell.timeLbl.text = flightDetail[indexPath.row]["time"] as? String
            
            return cell
            
        }else{
            let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("PriceDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
            
            
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
