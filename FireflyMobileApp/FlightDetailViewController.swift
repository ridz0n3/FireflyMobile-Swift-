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
    @IBOutlet weak var continueView: UIView!
    
    var flightDetail = NSArray()
    var planGoing:Int = 1
    var planReturn:Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        let header = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)[0] as! HeaderView
        header.lvlImg.image = UIImage(named: "book_flight2")

        self.flightDetailTableView.tableHeaderView = header
        
        if flightDetail.count == 0{
            self.continueView.hidden = true
        }
        
        //let flightDict = flightDetail[section] as! NSDictionary
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if flightDetail.count == 0{
            return 1
        }else{
            return flightDetail.count
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flightDetail.count == 0{
            return 1
        }else{
            let flightDict = flightDetail[section] as! NSDictionary
            
            if flightDict["flights"]?.count == 0{
                return 1
            }else{
                return (flightDict["flights"]?.count)!
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
            return 107
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if flightDetail.count == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("NoFlightCell", forIndexPath: indexPath)
            return cell
        }else{
            
            let flightDict = flightDetail[indexPath.section] as! NSDictionary
            
            if flightDict["flights"]?.count == 0{
                let cell = tableView.dequeueReusableCellWithIdentifier("NoFlightCell", forIndexPath: indexPath)
                return cell
            }else{
                let cell = self.flightDetailTableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! CustomFlightDetailTableViewCell
                
                let flightDict = flightDetail[indexPath.section] as! NSDictionary
                let flights = flightDict["flights"] as! NSArray
                let flightData = flights[indexPath.row] as! NSDictionary
                let flightBasic = flightData["basic_class"] as! NSDictionary
                let flightFlex = flightData["flex_class"] as! NSDictionary
                
                cell.flightNumber.text = String(format: "FLIGHT NO. FY %@", flightData["flight_number"] as! String)
                cell.departureAirportLbl.text = String(format: "%@ Airport", flightDict["departure_station_name"] as! String)
                cell.arrivalAirportLbl.text = String(format: "%@ Airport", flightDict["arrival_station_name"] as! String)
                cell.departureTimeLbl.text = flightData["departure_time"] as? String
                cell.arrivalTimeLbl.text = flightData["arrival_time"] as? String
                
                if (planGoing == 1 && indexPath.section == 0) || (planReturn == 4 && indexPath.section == 1){
                    cell.priceLbl.text = String(format: "MYR %.2f", (flightBasic["total_fare"]?.floatValue)!)
                }else{
                    
                    if flightFlex["status"] as! String == "sold out"{
                        cell.priceLbl.text = "SOLD OUT"
                    }else{
                        cell.priceLbl.text = String(format: "MYR %.2f", (flightFlex["total_fare"]?.floatValue)!)
                    }
                    
                }
                
                if indexPath.section == 1{
                    cell.flightIcon.image = UIImage(named: "arrival_icon")
                }else{
                    cell.flightIcon.image = UIImage(named: "departure_icon")
                }
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if flightDetail.count == 0{
            return 0
        }else{
            return 118
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if flightDetail.count == 0{
            return nil
        }else{
            let flightHeader = NSBundle.mainBundle().loadNibNamed("FlightHeader", owner: self, options: nil)[0] as! FlightHeaderView
            
            flightHeader.frame = CGRectMake(0, 0,self.view.frame.size.width, 118)
            
            let flightDict = flightDetail[section] as! NSDictionary
            
            if (planGoing == 1 && section == 0) || (planReturn == 4 && section == 1){
                flightHeader.basicBtn.backgroundColor = UIColor.whiteColor()
                flightHeader.premierBtn.backgroundColor = UIColor.lightGrayColor()
            }else if (planGoing == 2 && section == 0) || (planReturn == 5 && section == 1){
                flightHeader.basicBtn.backgroundColor = UIColor.lightGrayColor()
                flightHeader.premierBtn.backgroundColor = UIColor.whiteColor()
            }
            
            flightHeader.destinationLbl.text = String(format: "%@ - %@", flightDict["departure_station_name"] as! String,flightDict["arrival_station_name"] as! String) //"PENANG - SUBANG"
            flightHeader.wayLbl.text = String(format: "(%@)", flightDict["type"] as! String)// "(Return Flight)"
            flightHeader.dateLbl.text = String(format: "%@", flightDict["departure_date"] as! String) //"26 JAN 2015"
            
            flightHeader.basicBtn.addTarget(self, action: "changePlan:", forControlEvents: .TouchUpInside)
            if section == 0 {
                flightHeader.basicBtn.tag = section+1
                flightHeader.premierBtn.tag = section+2
            }else{
                flightHeader.basicBtn.tag = section+3
                flightHeader.premierBtn.tag = section+4
            }
            
            flightHeader.premierBtn.addTarget(self, action: "changePlan:", forControlEvents: .TouchUpInside)
        
        
            return flightHeader
        }
    }
    
    func changePlan(sender:UIButton){
        
        let buttonTouch = sender
        print(buttonTouch.tag)
        
        if buttonTouch.tag == 1 || buttonTouch.tag == 2{
            planGoing = buttonTouch.tag
        }else{
            planReturn = buttonTouch.tag
        }
        
        self.flightDetailTableView.reloadData()
        
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
