//
//  CommonListViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/16/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class CommonListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var LoginMobileCheckinTableView: UITableView!
    
    var isOffline = Bool()
    var pnrList : Results<PNRList>! = nil
    
    var userId = String()
    var signature = String()
    var listBooking = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isOffline{
            return pnrList.count
        }else{
            return listBooking.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = LoginMobileCheckinTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
        
        if isOffline{
            let bookingList = pnrList[indexPath.row]
            
            cell.flightNumber.text = "\(bookingList.departureStationCode) - \(bookingList.arrivalStationCode)"
            cell.flightDate.text = bookingList.departureDayDate
            
        }else{
            let bookingList = listBooking[indexPath.row] as! NSDictionary
            
            cell.flightNumber.text = "\(bookingList["departure_station_code"]!) - \(bookingList["arrival_station_code"]!)"
            cell.flightDate.text = "\(bookingList["date"]!)"
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
