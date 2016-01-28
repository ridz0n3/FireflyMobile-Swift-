//
//  EditSearchFlightViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/25/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox
import ActionSheetPicker_3_0
import SwiftyJSON

class EditSearchFlightViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var sectionHeader: UIView!
    @IBOutlet weak var wayLbl: UILabel!
    @IBOutlet weak var checkBox: M13Checkbox!
    @IBOutlet weak var editFlightTableView: UITableView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    var arrivalDate = NSDate()
    var goingDate = String()
    var isChangeGoingDate = Bool()
    var returnDate = String()
    var isChangeReturnDate = Bool()
    var flightDetail = NSArray()
    var isCheckGoing = Bool()
    var isCheckReturn = Bool()
    
    var goingDeparture = String()
    var goingArrival = String()
    var returnDeparture = String()
    var returnArrival = String()
    
    var bookId = String()
    var signature = String()
    var pnr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        
        continueBtn.layer.cornerRadius = 10.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "departureDate:", name: "departure", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "returnDate:", name: "return", object: nil)
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
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = editFlightTableView.dequeueReusableCellWithIdentifier("airportCell", forIndexPath: indexPath) as! CustomSearchFlightTableViewCell
        
        let flightData = flightDetail[indexPath.section] as! NSDictionary
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        
        if (indexPath.section == 0 && !isCheckGoing) || (indexPath.section == 1 && !isCheckReturn){
            cell.bgView.backgroundColor = UIColor.lightGrayColor()
        }else{
            cell.bgView.backgroundColor = UIColor.whiteColor()
        }
        
        if indexPath.row == 0{
            cell.iconImg.image = UIImage(named: "departure_icon")
            cell.airportLbl.text = "\(getFlightName(flightData["departure_station"] as! String))(\(flightData["departure_station"] as! String))"
            cell.airportLbl.tag = indexPath.row
            
            if indexPath.section == 0{
                goingDeparture = flightData["departure_station"] as! String
            }else{
                returnDeparture = flightData["departure_station"] as! String
            }
            
        }else if indexPath.row == 1{
            cell.iconImg.image = UIImage(named: "arrival_icon")
            cell.airportLbl.text = "\(getFlightName(flightData["arrival_station"] as! String))(\(flightData["arrival_station"] as! String))"
            cell.airportLbl.tag = indexPath.row
            cell.lineStyle.image = UIImage(named: "lines")
            
            if indexPath.section == 0{
                goingArrival = flightData["arrival_station"] as! String
            }else{
                returnArrival = flightData["arrival_station"] as! String
            }
        }else{
            cell.iconImg.image = UIImage(named: "date_icon")
            
            if indexPath.section == 0{
                
                if !isChangeGoingDate{
                    let rawDate = (flightData["departure_date"] as! String).componentsSeparatedByString("/")
                    let dateStr = formater.dateFromString("\(rawDate[2])/\(rawDate[1])/\(rawDate[0])")
                    goingDate = formater.stringFromDate(dateStr!)
                    cell.airportLbl.text = goingDate
                    
                }else{
                    let date = formater.dateFromString(goingDate)
                    cell.airportLbl.text = formater.stringFromDate(date!)
                }
                
                cell.userInteractionEnabled = isCheckGoing
                
            }else{
                if !isChangeReturnDate{
                    let rawDate = (flightData["departure_date"] as! String).componentsSeparatedByString("/")
                    let dateStr = formater.dateFromString("\(rawDate[2])/\(rawDate[1])/\(rawDate[0])")
                    returnDate = formater.stringFromDate(dateStr!)
                    cell.airportLbl.text = returnDate
                    
                }else{
                    let date = formater.dateFromString(returnDate)
                    cell.airportLbl.text = formater.stringFromDate(date!)
                }
                
                cell.userInteractionEnabled = isCheckReturn
            }
            
            cell.airportLbl.tag = indexPath.row
        }
        
        //cell.userInteractionEnabled = userInteract
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 2{
            
            if indexPath.section == 0{
                let storyBoard = UIStoryboard(name: "RSDFDatePicker", bundle: nil)
                let gregorianVC = storyBoard.instantiateViewControllerWithIdentifier("DatePickerVC") as! RSDFDatePickerViewController
                gregorianVC.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                //gregorianVC.calendar.locale = NSLocale.currentLocale()
                gregorianVC.view.backgroundColor = UIColor.orangeColor()
                gregorianVC.typeDate = "departure"
                self.presentViewController(gregorianVC, animated: true, completion: nil)
            }else{
                let storyBoard = UIStoryboard(name: "RSDFDatePicker", bundle: nil)
                let gregorianVC = storyBoard.instantiateViewControllerWithIdentifier("DatePickerVC") as! RSDFDatePickerViewController
                gregorianVC.currentDate = arrivalDate
                gregorianVC.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                //gregorianVC.calendar.locale = NSLocale.currentLocale()
                gregorianVC.view.backgroundColor = UIColor.orangeColor()
                gregorianVC.typeDate = "return"
                self.presentViewController(gregorianVC, animated: true, completion: nil)
            }
            
            
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        sectionHeader = NSBundle.mainBundle().loadNibNamed("FlightHeaderView", owner: self, options: nil)[0] as! UIView
        
        sectionHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        checkBox.uncheckedColor = UIColor.whiteColor()
        checkBtn.tag = section
        if (section == 1) {
            wayLbl.text = "RETURN FLIGHT"
            if isCheckReturn{
                checkBox.checkState = M13CheckboxStateChecked
            }else{
                checkBox.checkState = M13CheckboxStateUnchecked
            }
        }else{
            if isCheckGoing{
                checkBox.checkState = M13CheckboxStateChecked
            }else{
                checkBox.checkState = M13CheckboxStateUnchecked
            }
        }
        
        checkBtn.addTarget(self, action: "checkSection:", forControlEvents: .TouchUpInside)
        return sectionHeader
        
    }
    
    func departureDate(notif:NSNotification){
        isChangeGoingDate = true
        goingDate = notif.userInfo!["date"] as! String
        arrivalDate = stringToDate(goingDate)
        editFlightTableView.reloadData()
        
    }
    
    func returnDate(notif:NSNotification){
        isChangeReturnDate = true
        returnDate = notif.userInfo!["date"] as! String
        //arrivalDate = stringToDate(goingDate)
        editFlightTableView.reloadData()
        
    }
    
    func checkSection(sender:UIButton){
        
        if flightDetail[sender.tag]["flight_status"] as! String == "Checked_in"{
            showToastMessage("Checked-in flight cannot be changed.")
        }else if flightDetail[sender.tag]["flight_status"] as! String == "Departed_flight"{
            showToastMessage("Departed flight cannot be changed.")
        }else{
            if sender.tag == 0 && !isCheckGoing{
                isCheckGoing = true
            }else if sender.tag == 1 && !isCheckReturn{
                isCheckReturn = true
            }else if sender.tag == 0 && isCheckGoing{
                isCheckGoing = false
                isChangeGoingDate = false
            }else if sender.tag == 1 && isCheckReturn{
                isCheckReturn = false
                isChangeReturnDate = false
            }
            
            editFlightTableView.reloadData()
        }
        
    }
    
    func getFlightName(flightCode : String) -> String{
        
        let flightArr = defaults.objectForKey("flight") as! NSArray
        var flightName = String()
        for flightData in flightArr{
            
            if flightData["location_code"] as! String == flightCode{
                flightName = flightData["location"] as! String
                break
            }
            
        }
        
        return flightName
        
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
        if !isCheckGoing && !isCheckReturn{
            showToastMessage("Please select at least one flight to proceed.")
        }else{
            
            let departure = NSMutableDictionary()
            let returned = NSMutableDictionary()
            
            departure.setValue(isCheckGoing ? "Y" : "N", forKey: "status")
            departure.setValue(goingDeparture, forKey: "departure_station")
            departure.setValue(goingArrival, forKey: "arrival_station")
            departure.setValue(formatDate(stringToDate(goingDate)), forKey: "departure_date")
            
            if flightDetail.count == 2{
                
                let gDate = stringToDate(goingDate)
                let rDate = stringToDate(returnDate)
                
                if gDate.compare(rDate) == NSComparisonResult.OrderedDescending{
                    showToastMessage("Please make sure that your return date is not earlier than your departure date.")
                }
                
                returned.setValue(isCheckReturn ? "Y" : "N", forKey: "status")
                returned.setValue(returnDeparture, forKey: "departure_station")
                returned.setValue(returnArrival, forKey: "arrival_station")
                returned.setValue(formatDate(stringToDate(returnDate)), forKey: "departure_date")
                
            }
            
            showHud()
            
            FireFlyProvider.request(.SearchChangeFlight(departure, returned, pnr, bookId, signature), completion: { (result) -> () in
                switch result {
                case .Success(let successResult):
                    do {
                        self.hideHud()
                        
                        let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                        
                        if json["status"] == "success"{
                            let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                            let changeFlightVC = storyboard.instantiateViewControllerWithIdentifier("EditFlightDetailVC") as! EditFlightDetailViewController
                            changeFlightVC.flightDetail = json["journeys"].arrayValue
                            
                            if json["type"] == 1{
                                changeFlightVC.returnData = json["return_flight"].dictionaryObject!
                            }
                            changeFlightVC.type = json["type"].int!
                            changeFlightVC.goingData = json["going_flight"].dictionaryObject!
                            changeFlightVC.signature = json["signature"].string!
                            
                            changeFlightVC.pnr = self.pnr
                            changeFlightVC.bookId = "\(self.bookId)"
                            changeFlightVC.signature = self.signature
                            self.navigationController!.pushViewController(changeFlightVC, animated: true)
                        }else{
                            self.showToastMessage(json["message"].string!)
                        }
                    }
                    catch {
                        
                    }
                    print (successResult.data)
                case .Failure(let failureResult):
                    print (failureResult)
                }
            })
            
            
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
