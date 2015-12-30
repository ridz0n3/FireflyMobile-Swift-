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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if flightDetail.count == 2{
            return 137 * 2
        }else{
            return 137
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.paymentTableView.dequeueReusableCellWithIdentifier("FlightDetailCell", forIndexPath: indexPath) as! CustomPaymentSummaryTableViewCell
        
        if flightDetail.count == 2{
            
            cell.goingLbl.text = flightDetail[0]["type"] as? String
            cell.goingDateLbl.text = flightDetail[0]["date"] as? String
            cell.goingDestinationLbl.text = flightDetail[0]["station"] as? String
            cell.goingFlightNumberLbl.text = flightDetail[0]["flight_number"] as? String
            cell.goingTimeLbl.text = flightDetail[0]["time"] as? String
            
            cell.returnLbl.text = flightDetail[1]["type"] as? String
            cell.returnDateLbl.text = flightDetail[1]["date"] as? String
            cell.returnDestinationLbl.text = flightDetail[1]["station"] as? String
            cell.returnFlightNumberLbl.text = flightDetail[1]["flight_number"] as? String
            cell.returnTimeLbl.text = flightDetail[1]["time"] as? String
            
        }
        
        return cell
        
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
