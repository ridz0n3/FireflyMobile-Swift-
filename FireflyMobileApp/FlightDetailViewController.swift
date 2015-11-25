//
//  FlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class FlightDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var flightDetailTableView: UITableView!
    var flightDetail = NSArray()
    
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
        return flightDetail.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let flightDict = flightDetail[section] as! NSDictionary
        return (flightDict["flights"]?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.flightDetailTableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! CustomFlightDetailTableViewCell
        
        let flightDict = flightDetail[indexPath.section] as! NSDictionary
        let flights = flightDict["flights"] as! NSArray
        let flightData = flights[indexPath.row] as! NSDictionary
        
        cell.flightNumber.text = String(format: "FLIGHT NO. FY %@", flightData["flight_number"] as! String)
        cell.departureAirportLbl.text = String(format: "%@ Airport", flightDict["departure_station_name"] as! String)
        cell.arrivalAirportLbl.text = String(format: "%@ Airport", flightDict["arrival_station_name"] as! String)
        cell.departureTimeLbl.text = flightData["departure_time"] as? String
        cell.arrivalTimeLbl.text = flightData["arrival_time"] as? String
        cell.priceLbl.text = String(format: "MYR %.2f", (flightData["total_fare"]?.floatValue)!)
        
        if indexPath.section == 1{
            cell.flightIcon.image = UIImage(named: "arrival_icon")
        }else{
            cell.flightIcon.image = UIImage(named: "departure_icon")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 118
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let flightHeader = NSBundle.mainBundle().loadNibNamed("FlightHeader", owner: self, options: nil)[0] as! FlightHeaderView
        
        flightHeader.frame = CGRectMake(0, 0,self.view.frame.size.width, 118)
        
        let flightDict = flightDetail[section] as! NSDictionary
        
        
        flightHeader.destinationLbl.text = String(format: "%@ - %@", flightDict["departure_station_name"] as! String,flightDict["arrival_station_name"] as! String) //"PENANG - SUBANG"
        flightHeader.wayLbl.text = String(format: "(%@)", flightDict["type"] as! String)// "(Return Flight)"
        flightHeader.dateLbl.text = String(format: "%@", flightDict["departure_date"] as! String) //"26 JAN 2015"
        
        return flightHeader
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
        let personalDetailVC = storyboard.instantiateViewControllerWithIdentifier("PersonalDetailVC") as! PersonalDetailViewController
        self.navigationController!.pushViewController(personalDetailVC, animated: true)
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
