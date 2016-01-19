//
//  EditFlightDetailViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 1/18/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit
import M13Checkbox
import ActionSheetPicker_3_0

class EditFlightDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var sectionHeader: UIView!
    @IBOutlet weak var wayLbl: UILabel!
    @IBOutlet weak var checkBox: M13Checkbox!
    @IBOutlet weak var editFlightTableView: UITableView!
    
    var arrivalDate = NSDate()
    var newDate = String()
    var goingDate = String()
    var isChangeGoingDate = Bool()
    var returnDate = String()
    var isChangeReturnDate = Bool()
    var userInteract = Bool()
    var flightDetail = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftButton()
        getDepartureAirport()
        userInteract = false
        
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
        let destination = (flightData["station"] as! String).componentsSeparatedByString(" to ")
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        
        if indexPath.row == 0{
            cell.iconImg.image = UIImage(named: "departure_icon")
            cell.airportLbl.text = "\(destination[0])"
            cell.airportLbl.tag = indexPath.row
        }else if indexPath.row == 1{
            cell.iconImg.image = UIImage(named: "arrival_icon")
            cell.airportLbl.text = "\(destination[1])"
            cell.airportLbl.tag = indexPath.row
            cell.lineStyle.image = UIImage(named: "lines")
        }else{
            cell.iconImg.image = UIImage(named: "date_icon")
            
            if indexPath.section == 0{
                
                if !isChangeGoingDate{
                    let rawDate = flightData["date"] as! String
                    let date = rawDate.componentsSeparatedByString(", ")
                    let dateArr = date[1].componentsSeparatedByString(" ")
                    
                    let dateStr = formater.dateFromString("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])")
                    goingDate = formater.stringFromDate(dateStr!)
                    cell.airportLbl.text = goingDate
                }else{
                    let date = formater.dateFromString(goingDate)
                    cell.airportLbl.text = formater.stringFromDate(date!)
                }
                
            }else{
                if !isChangeReturnDate{
                    let rawDate = flightData["date"] as! String
                    let date = rawDate.componentsSeparatedByString(", ")
                    let dateArr = date[1].componentsSeparatedByString(" ")
                    
                    let dateStr = formater.dateFromString("\(dateArr[2])-\(dateArr[1])-\(dateArr[0])")
                    returnDate = formater.stringFromDate(dateStr!)
                    cell.airportLbl.text = returnDate
                }else{
                    let date = formater.dateFromString(returnDate)
                    cell.airportLbl.text = formater.stringFromDate(date!)
                }
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
        checkBox.tag = section
        if (section == 1) {
            wayLbl.text = "RETURN FLIGHT"
        }
        checkBox.addTarget(self, action: "checkSection:", forControlEvents: .TouchUpInside)
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
    
    func checkSection(sender:M13Checkbox){
        
        print(sender.tag)
        
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
