//
//  LoginManageFlightViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/27/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginManageFlightViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var loginManageFlightTableView: UITableView!
    
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
        return listBooking.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = loginManageFlightTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomLoginManageFlightTableViewCell
        
        let bookingList = listBooking[indexPath.row] as! NSDictionary
        
        cell.flightNumber.text = "\(bookingList["pnr"]!)"
        cell.flightDate.text = "\(bookingList["date"]!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let bookingList = listBooking[indexPath.row] as! NSDictionary
        let userInfo = defaults.objectForKey("userInfo") as! [String:AnyObject]
        let username = userInfo["username"] as! String
        showLoading(self) //showHud("open")
        
        FireFlyProvider.request(.RetrieveBooking(signature, bookingList["pnr"] as! String,username, userId)) { (result) -> () in
            //showHud("close")
            switch result {
            case .Success(let successResult):
                do {
                    let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                    
                    if json["status"] == "success"{
                        
                        defaults.setObject(json.object, forKey: "manageFlight")
                        defaults.synchronize()
                        
                        let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                        let manageFlightVC = storyboard.instantiateViewControllerWithIdentifier("ManageFlightMenuVC") as! ManageFlightHomeViewController
                        manageFlightVC.isLogin = true
                        self.navigationController!.pushViewController(manageFlightVC, animated: true)
                        
                    }else if json["status"].string == "error"{
                        //showErrorMessage(json["message"].string!)
                                showErrorMessage(json["message"].string!)
                    }
                    hideLoading(self)
                }
                catch {
                    
                }
                
            case .Failure(let failureResult):
                hideLoading(self)
                showErrorMessage(failureResult.nsError.localizedDescription)
            }

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
