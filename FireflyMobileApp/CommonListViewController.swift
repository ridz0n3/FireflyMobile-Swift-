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
    var checkInList : Results<CheckInList>! = nil
    var mainUser : Results<UserList>! = nil
    var indicator = Bool()
    var module = String()
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1//newFormatedBookingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if module == "checkIn"{
            return checkInList.count
        }else{
            return pnrList.count
        }
        /*
        if isOffline{
            return pnrList.count
        }else{
            return listBooking.count
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LoginMobileCheckinTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! CustomLoginManageFlightTableViewCell
        
        if module == "checkIn"{
            let bookingList = checkInList[indexPath.row]
            
            cell.pnrNumber.text = "\(bookingList.pnr)"
            cell.flightNumber.text = "\(bookingList.departureStationCode) - \(bookingList.arrivalStationCode)"
            cell.flightDate.text = bookingList.departureDayDate.capitalized
            
        }else{
            let bookingList = pnrList[indexPath.row]
            cell.pnrNumber.text = "\(bookingList.pnr)"
            cell.flightNumber.text = "\(bookingList.departureStationCode) - \(bookingList.arrivalStationCode)"
            cell.flightDate.text = bookingList.departureDayDate.capitalized
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
