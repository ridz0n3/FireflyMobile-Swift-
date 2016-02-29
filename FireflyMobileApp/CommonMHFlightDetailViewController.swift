//
//  CommonMHFlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 2/28/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommonMHFlightDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var flightDetailTableView: UITableView!
    @IBOutlet weak var continueView: UIView!
    
    var infant = String()
    var adult = String()
    var flightDetail : Array<JSON> = []
    var checkGoingIndexPath = NSIndexPath()
    var checkReturnIndexPath = NSIndexPath()
    var checkGoingIndex = String()
    var checkReturnIndex = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        if flightDetail.count == 0{
            self.continueView.hidden = true
        }
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
            let flightDict = flightDetail[section].dictionary
            
            if flightDict!["flights"]?.count == 0{
                return 1
            }else{
                return (flightDict!["flights"]?.count)!
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let flightDict = flightDetail[indexPath.section].dictionary
        
        if flightDict!["flights"]?.count == 0{
            return 107
        }else{
            return 222
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if flightDetail.count == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("NoFlightCell", forIndexPath: indexPath)
            return cell
        }else{
            
            let flightDict = flightDetail[indexPath.section].dictionary
            
            if flightDict!["flights"]?.count == 0{
                let cell = tableView.dequeueReusableCellWithIdentifier("NoFlightCell", forIndexPath: indexPath)
                return cell
            }else{
                let cell = self.flightDetailTableView.dequeueReusableCellWithIdentifier("flightCell", forIndexPath: indexPath) as! CustomMHFlightDetailTableViewCell
                
                let flights = flightDict!["flights"]?.array
                let flightData = flights![indexPath.row].dictionary
                
                let economyPromo = flightData!["economy_promo_class"]!.dictionary
                let economy = flightData!["economy_class"]!.dictionary
                let business = flightData!["business_class"]!.dictionary
                
                cell.flightNumber.text = String(format: "FLIGHT NO. FY %@", flightData!["flight_number"]!.string!)
                cell.departureAirportLbl.text = "\(flightDict!["departure_station_name"]!.stringValue)"
                cell.arrivalAirportLbl.text = "\(flightDict!["arrival_station_name"]!.stringValue)"
                cell.departureTimeLbl.text = flightData!["departure_time"]!.string
                cell.arrivalTimeLbl.text = flightData!["arrival_time"]!.string
                
                if economyPromo!["status"]?.string == "sold out"{
                    cell.economyPromoSoldView.hidden = false
                    cell.economyPromoBtn.hidden = true
                }else{
                    cell.economyPromoSoldView.hidden = true
                    cell.economyPromoBtn.hidden = false
                    
                    cell.economyPromoBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:1"
                    cell.economyPromoBtn.addTarget(self, action: "checkCategory:", forControlEvents: .TouchUpInside)
                    
                }
                
                if economy!["status"]?.string == "sold out"{
                    cell.economySoldView.hidden = false
                }else{
                    cell.economySoldView.hidden = true
                    cell.economyPriceLbl.text = "MYR \(economy!["fare_price"]!.floatValue)"
                    
                    cell.economyBtn.hidden = false
                    
                    cell.economyBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:2"
                    cell.economyBtn.addTarget(self, action: "checkCategory:", forControlEvents: .TouchUpInside)
                }
                
                if business!["status"]?.string == "sold out"{
                    cell.businessSoldView.hidden = false
                }else{
                    cell.businessSoldView.hidden = true
                    
                    cell.businessBtn.hidden = false
                    
                    cell.businessBtn.accessibilityHint = "section:\(indexPath.section) row:\(indexPath.row) index:3"
                    cell.businessBtn.addTarget(self, action: "checkCategory:", forControlEvents: .TouchUpInside)
                }
                
                if indexPath.section == 1{
                    cell.flightIcon.image = UIImage(named: "arrival_icon")
                    if checkReturnIndexPath.section == 1{
                        if checkReturnIndexPath.row == indexPath.row{
                            if checkReturnIndex == "1"{
                                cell.economyPromoCheckBox.checkState = .Checked
                            }else if checkReturnIndex == "2"{
                                cell.economyCheckBox.checkState = .Checked
                            }else if checkReturnIndex == "3"{
                                cell.businessCheckBox.checkState = .Checked
                            }
                        }else{
                            cell.economyPromoCheckBox.checkState = .Unchecked
                            cell.economyCheckBox.checkState = .Unchecked
                            cell.businessCheckBox.checkState = .Unchecked
                        }
                    }else{
                        cell.economyPromoCheckBox.checkState = .Unchecked
                        cell.economyCheckBox.checkState = .Unchecked
                        cell.businessCheckBox.checkState = .Unchecked
                    }
                }else{
                    cell.flightIcon.image = UIImage(named: "departure_icon")
                    if checkGoingIndexPath.section == 0{
                        if checkGoingIndexPath.row == indexPath.row{
                            if checkGoingIndex == "1"{
                                cell.economyPromoCheckBox.checkState = .Checked
                            }else if checkGoingIndex == "2"{
                                cell.economyCheckBox.checkState = .Checked
                            }else if checkGoingIndex == "3"{
                                cell.businessCheckBox.checkState = .Checked
                            }
                        }else{
                            cell.economyPromoCheckBox.checkState = .Unchecked
                            cell.economyCheckBox.checkState = .Unchecked
                            cell.businessCheckBox.checkState = .Unchecked
                        }
                    }else{
                        cell.economyPromoCheckBox.checkState = .Unchecked
                        cell.economyCheckBox.checkState = .Unchecked
                        cell.businessCheckBox.checkState = .Unchecked
                    }
                }
                return cell
            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 88
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let flightHeader = NSBundle.mainBundle().loadNibNamed("MHFlightHeaderView", owner: self, options: nil)[0] as! MHFlightHeaderView
        
        let flightDict = flightDetail[section].dictionary
        
        flightHeader.destinationLbl.text = String(format: "%@ - %@", (flightDict!["departure_station_name"]?.string?.uppercaseString)!,flightDict!["arrival_station_name"]!.string!.uppercaseString) //"PENANG - SUBANG"
        flightHeader.directionLbl.text = String(format: "(%@)", flightDict!["type"]!.string!)// "(Return Flight)"
        flightHeader.dateLbl.text = String(format: "%@", flightDict!["departure_date"]!.string!) //"26 JAN 2015"
        
        flightHeader.frame = CGRectMake(0, 0,self.view.frame.size.width, 88)
        return flightHeader
    }
    
    func checkCategory(sender : UIButton){
        let index = sender.accessibilityHint?.componentsSeparatedByString(" ")
        let section = index![0].componentsSeparatedByString(":")
        let row = index![1].componentsSeparatedByString(":")
        let indexCheck = index![2].componentsSeparatedByString(":")
        
        if section[1] == "0"{
            checkGoingIndex = indexCheck[1]
            checkGoingIndexPath = NSIndexPath(forRow: Int(row[1])!, inSection: Int(section[1])!)
        }else{
            checkReturnIndex = indexCheck[1]
            checkReturnIndexPath = NSIndexPath(forRow: Int(row[1])!, inSection: Int(section[1])!)
        }
        
        flightDetailTableView.reloadData()
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
