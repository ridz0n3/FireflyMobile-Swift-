//
//  CommonFlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/25/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import M13Checkbox

class CommonFlightDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var flightDetailTableView: UITableView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var fareRule: UITextView!
    @IBOutlet weak var termCondition: UITextView!
    @IBOutlet weak var termCheckBox: M13Checkbox!
    @IBOutlet weak var continueBtn: UIButton!
    
    var selectedGoingFlight = NSNumber()
    var selectedGoingCell:NSNumber? = nil
    var selectedReturnFlight = NSNumber()
    var selectedReturnCell:NSNumber? = nil
    var flightDetail : Array<JSON> = []
    var infant = String()
    var adult = String()
    var planGoing:Int = 1
    var planReturn:Int = 4
    var flightAvailable = Bool()
    var isGoingSelected = Bool()
    var isReturnSelected = Bool()
    var isEdit = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        setupLeftButton()
        
        self.flightDetailTableView.tableHeaderView = headerView
        isGoingSelected = false
        isReturnSelected = false
        flightAvailable = true
        
        if flightDetail.count == 0{
            self.continueView.isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if flightDetail.count == 0{
            return 1
        }else{
            return flightDetail.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if flightDetail.count != 0{
            
            let flightDict = flightDetail[indexPath.section].dictionary
            
            if flightDict!["flights"]?.count == 0{
                return 105
            }else{
                
                let flights = flightDict!["flights"]?.array
                let flightData = flights![indexPath.row].dictionary
                let flightBasic = flightData!["basic_class"]!.dictionary
                
                if flightBasic!["discount"]?.floatValue == 0{
                    return 105
                }else{
                    return 130
                }
                
            }
        }else{
            return 105
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if flightDetail.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoFyFlightCell", for: indexPath)
            
            return cell
        }else{
            
            let flightDict = flightDetail[indexPath.section].dictionary
            
            if flightDict!["flights"]?.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoFyFlightCell", for: indexPath)
                return cell
            }else{
                let cell = self.flightDetailTableView.dequeueReusableCell(withIdentifier: "fyFlightCell", for: indexPath) as! CustomFlightDetailTableViewCell
                
                let flightDict = flightDetail[indexPath.section].dictionary
                let flights = flightDict!["flights"]?.array
                let flightData = flights![indexPath.row].dictionary
                let flightBasic = flightData!["basic_class"]!.dictionary
                let flightFlex = flightData!["flex_class"]!.dictionary
                
                cell.flightNumber.text = String(format: "FLIGHT NO. FY %@", flightData!["flight_number"]!.string!)
                cell.departureAirportLbl.text = "\(flightDict!["departure_station_name"]!.stringValue)"
                cell.arrivalAirportLbl.text = "\(flightDict!["arrival_station_name"]!.stringValue)"
                cell.departureTimeLbl.text = flightData!["departure_time"]!.string
                cell.arrivalTimeLbl.text = flightData!["arrival_time"]!.string
                cell.checkFlight.tag = indexPath.row
                
                cell.checkFlight.strokeColor = UIColor.orange
                cell.checkFlight.checkColor = UIColor.orange
                if (planGoing == 1 && indexPath.section == 0) || (planReturn == 4 && indexPath.section == 1){
                    if flightBasic!["status"]!.string == "sold out"{
                        cell.priceLbl.text = "SOLD OUT"
                        cell.checkFlight.isHidden = true
                        cell.checkFlight.checkState = M13CheckboxState.unchecked
                        flightAvailable = false
                        
                    }else{
                        if flightBasic!["discount"]?.floatValue == 0{
                            cell.priceLbl.text = String(format: "%.2f MYR", (flightBasic!["total_fare"]?.floatValue)!)
                            cell.promoPriceLbl.isHidden = true
                            cell.checkFlight.isHidden = false
                            cell.strikeDegree.isHidden = true
                            flightAvailable = true
                        }else{
                            cell.promoPriceLbl.text = String(format: "%.2f MYR", (flightBasic!["total_fare"]?.floatValue)!)
                            cell.priceLbl.text = String(format: "%.2f MYR", (flightBasic!["before_discount_fare"]?.floatValue)!)
                            cell.promoPriceLbl.isHidden = false
                            cell.strikeDegree.isHidden = false
                            cell.checkFlight.isHidden = false
                            flightAvailable = true
                        }
                        
                        
                    }
                }else{
                    
                    if flightFlex!["status"]!.string == "sold out"{
                        cell.priceLbl.text = "SOLD OUT"
                        cell.checkFlight.isHidden = true
                        cell.checkFlight.checkState = M13CheckboxState.unchecked
                        flightAvailable = false
                        
                    }else{
                        cell.priceLbl.text = String(format: "%.2f MYR", (flightFlex!["total_fare"]?.floatValue)!)
                        cell.checkFlight.isHidden = false
                    }
                    
                }
                
                if indexPath.section == 1{
                    cell.flightIcon.image = UIImage(named: "arrival_icon")
                    cell.checkFlight.isUserInteractionEnabled = false
                    if NSNumber.init(value: indexPath.row) == selectedReturnFlight{
                        selectedReturnFlight = NSNumber.init(value: indexPath.row)
                        cell.checkFlight.checkState = M13CheckboxState.checked
                    }else{
                        cell.checkFlight.checkState = M13CheckboxState.unchecked
                    }
                }else{
                    cell.flightIcon.image = UIImage(named: "departure_icon")
                    cell.checkFlight.isUserInteractionEnabled = false
                    if NSNumber.init(value: indexPath.row) == selectedGoingFlight{
                        selectedGoingFlight = NSNumber.init(value: indexPath.row)
                        cell.checkFlight.checkState = M13CheckboxState.checked
                    }else{
                        cell.checkFlight.checkState = M13CheckboxState.unchecked
                    }
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if flightDetail.count == 0{
            return 0
        }else{
            return 88//118
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if flightDetail.count == 0{
            return nil
        }else{
            
            //FLIGHT HEADER WITH BASIC & PREMIER BUTTON
            /*let flightHeader = Bundle.main.loadNibNamed("FlightHeader", owner: self, options: nil)[0] as! FlightHeaderView
            
            flightHeader.frame = CGRectMake(0, 0,self.view.frame.size.width, 88)
            let flightDict = flightDetail[section].dictionary
            
            if (planGoing == 1 && section == 0) || (planReturn == 4 && section == 1){
                flightHeader.basicBtn.backgroundColor = UIColor.whiteColor()
                flightHeader.premierBtn.backgroundColor = UIColor.lightGrayColor()
            }else if (planGoing == 2 && section == 0) || (planReturn == 5 && section == 1){
                flightHeader.basicBtn.backgroundColor = UIColor.lightGrayColor()
                flightHeader.premierBtn.backgroundColor = UIColor.whiteColor()
            }
            
            flightHeader.destinationLbl.text = String(format: "%@ - %@", (flightDict!["departure_station_name"]?.string?.uppercaseString)!,flightDict!["arrival_station_name"]!.string!.uppercaseString) //"PENANG - SUBANG"
            flightHeader.wayLbl.text = String(format: "(%@)", flightDict!["type"]!.string!)// "(Return Flight)"
            flightHeader.dateLbl.text = String(format: "%@", flightDict!["departure_date"]!.string!) //"26 JAN 2015"
            
            flightHeader.basicBtn.addTarget(self, action: "changePlan:", forControlEvents: .TouchUpInside)
            if section == 0 {
                flightHeader.basicBtn.tag = section+1
                flightHeader.premierBtn.tag = section+2
            }else{
                flightHeader.basicBtn.tag = section+3
                flightHeader.premierBtn.tag = section+4
            }
            
            flightHeader.premierBtn.addTarget(self, action: "changePlan:", forControlEvents: .TouchUpInside)
            */
            
            let flightHeader = Bundle.main.loadNibNamed("MHFlightHeaderView", owner: self, options: nil)?[0] as! MHFlightHeaderView
            
            let flightDict = flightDetail[section].dictionary
            
            flightHeader.destinationLbl.text = String(format: "%@ - %@", (flightDict!["departure_station_name"]?.string?.uppercased())!,flightDict!["arrival_station_name"]!.string!.uppercased()) //"PENANG - SUBANG"
            flightHeader.directionLbl.text = String(format: "(%@)", flightDict!["type"]!.string!)// "(Return Flight)"
            flightHeader.dateLbl.text = String(format: "%@", flightDict!["departure_date"]!.string!) //"26 JAN 2015"
            
            flightHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 88)
            return flightHeader
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            selectedReturnFlight = NSNumber(value: indexPath.row)
            self.flightDetailTableView.reloadData()
            isReturnSelected = true
        }else{
            selectedGoingFlight = NSNumber(value: indexPath.row)
            self.flightDetailTableView.reloadData()
            isGoingSelected = true
        }
    }
    
    func changePlan(_ sender:UIButton){
        
        let buttonTouch = sender
        print(buttonTouch.tag)
        
        if buttonTouch.tag == 1 || buttonTouch.tag == 2{
            planGoing = buttonTouch.tag
        }else{
            planReturn = buttonTouch.tag
        }
        
        self.flightDetailTableView.reloadData()
        
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
