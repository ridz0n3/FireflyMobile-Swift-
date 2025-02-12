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
    
    var departDate = NSDate()
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
        AnalyticsManager.sharedInstance.logScreen(GAConstants.editSearchFlightScreen)
        setupLeftButton()
        
        continueBtn.layer.cornerRadius = 10.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditSearchFlightViewController.departureDate(_:)), name: "departure", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditSearchFlightViewController.returnDate(_:)), name: "return", object: nil)
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
        formater.dateFormat = "yyyy-MM-dd"
        let twentyFour = NSLocale(localeIdentifier: "en_GB")
        formater.locale = twentyFour
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
                    let date = (flightData["departure_date"] as! String).componentsSeparatedByString("/")
                    
                    let dateStr = formater.dateFromString("\(date[2])-\(date[1])-\(date[0])")
                    departDate = dateStr!
                    nonFormatGoingDate = formater.stringFromDate(dateStr!)
                    cell.airportLbl.text = flightData["departure_date"] as? String
                    
                }else{
                    cell.airportLbl.text = goingDate
                }
                
                cell.userInteractionEnabled = isCheckGoing
                
            }else{
                if !isChangeReturnDate{
                    let date = (flightData["departure_date"] as! String).componentsSeparatedByString("/")
                    
                    let dateStr = formater.dateFromString("\(date[2])-\(date[1])-\(date[0])")
                    arrivalDate = dateStr!
                    nonFormatReturnDate = formater.stringFromDate(dateStr!)
                    cell.airportLbl.text = flightData["departure_date"] as? String
                    
                }else{
                    cell.airportLbl.text = returnDate
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
                gregorianVC.dateSelected = departDate
                gregorianVC.isDepart = true
                gregorianVC.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                //gregorianVC.calendar.locale = NSLocale.currentLocale()
                gregorianVC.view.backgroundColor = UIColor.orangeColor()
                gregorianVC.typeDate = "departure"
                self.presentViewController(gregorianVC, animated: true, completion: nil)
            }else{
                let storyBoard = UIStoryboard(name: "RSDFDatePicker", bundle: nil)
                let gregorianVC = storyBoard.instantiateViewControllerWithIdentifier("DatePickerVC") as! RSDFDatePickerViewController
                gregorianVC.dateSelected = arrivalDate
                gregorianVC.currentDate = departDate
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
        checkBox.strokeColor = UIColor.orangeColor()
        checkBox.checkColor = UIColor.orangeColor()
        checkBtn.tag = section
        if (section == 1) {
            wayLbl.text = "RETURN FLIGHT"
            if isCheckReturn{
                checkBox.checkState = M13CheckboxState.Checked
            }else{
                checkBox.checkState = M13CheckboxState.Unchecked
            }
        }else{
            if isCheckGoing{
                checkBox.checkState = M13CheckboxState.Checked
            }else{
                checkBox.checkState = M13CheckboxState.Unchecked
            }
        }
        
        checkBtn.addTarget(self, action: #selector(EditSearchFlightViewController.checkSection(_:)), forControlEvents: .TouchUpInside)
        return sectionHeader
        
    }
    
    var nonFormatGoingDate = String()
    var nonFormatReturnDate = String()
    
    func departureDate(notif:NSNotification){
        isChangeGoingDate = true
        
        let date = (notif.userInfo!["date"] as? String)!.componentsSeparatedByString("-")
        goingDate = "\(date[2])/\(date[1])/\(date[0])"
        
        nonFormatGoingDate = notif.userInfo!["date"] as! String
        departDate = stringToDate(notif.userInfo!["date"] as! String)
        editFlightTableView.reloadData()
        
    }
    
    func returnDate(notif:NSNotification){
        isChangeReturnDate = true
        let date = (notif.userInfo!["date"] as? String)!.componentsSeparatedByString("-")
        returnDate = "\(date[2])/\(date[1])/\(date[0])"
        nonFormatReturnDate = notif.userInfo!["date"] as! String
        arrivalDate = stringToDate(nonFormatReturnDate)
        editFlightTableView.reloadData()
        
    }
    
    func checkSection(sender:UIButton){
        
        let detail = flightDetail[sender.tag] as! [String: String]
        
        if detail["flight_status"]! as String == "Checked_in"{
            showErrorMessage("Checked-in flight cannot be changed.")
        }else if detail["flight_status"]! as String == "Departed_flight"{
            showErrorMessage("Departed flight cannot be changed.")
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
        
        let flightArr = defaults.objectForKey("flight") as! [Dictionary<String, AnyObject>]
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
            showErrorMessage("Please select at least one flight to proceed.")
        }else{
            var isValid = true
            let departure = NSMutableDictionary()
            let returned = NSMutableDictionary()
            
            departure.setValue(isCheckGoing ? "Y" : "N", forKey: "status")
            departure.setValue(goingDeparture, forKey: "departure_station")
            departure.setValue(goingArrival, forKey: "arrival_station")
            
            departure.setValue(formatDate(stringToDate(nonFormatGoingDate)), forKey: "departure_date")
            
            if flightDetail.count == 2{
                
                let gDate = stringToDate(nonFormatGoingDate)
                let rDate = stringToDate(nonFormatReturnDate)
                
                if gDate.compare(rDate) == NSComparisonResult.OrderedDescending{
                    showErrorMessage("Please make sure that your return date is not earlier than your departure date.")
                    isValid = false
                }
                
                returned.setValue(isCheckReturn ? "Y" : "N", forKey: "status")
                returned.setValue(returnDeparture, forKey: "departure_station")
                returned.setValue(returnArrival, forKey: "arrival_station")
                returned.setValue(formatDate(stringToDate(nonFormatReturnDate)), forKey: "departure_date")
                
            }
            
            
            if isValid{
                showLoading() 
                
                FireFlyProvider.request(.SearchChangeFlight(departure, returned, pnr, bookId, signature), completion: { (result) -> () in
                    switch result {
                    case .Success(let successResult):
                        do {
                            
                            let json = try JSON(NSJSONSerialization.JSONObjectWithData(successResult.data, options: .MutableContainers))
                            
                            if json["status"] == "success"{
                                
                                if json["flight_type"].string == "MH"{
                                    
                                    let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                    let changeFlightVC = storyboard.instantiateViewControllerWithIdentifier("EditMHFlightDetailVC") as! EditMHFlightDetailViewController
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
                                    
                                }
                                
                            }else if json["status"] == "error"{
                                
                                showErrorMessage(json["message"].string!)
                            }else if json["status"].string == "401"{
                                hideLoading()
                                showErrorMessage(json["message"].string!)
                                InitialLoadManager.sharedInstance.load()
                                
                                for views in (self.navigationController?.viewControllers)!{
                                    if views.classForCoder == HomeViewController.classForCoder(){
                                        self.navigationController?.popToViewController(views, animated: true)
                                        AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                    }
                                }
                            }
                            hideLoading()
                        }
                        catch {
                            
                        }
                        
                    case .Failure(let failureResult):
                        
                        hideLoading()
                        showErrorMessage(failureResult.nsError.localizedDescription)
                    }
                })
                
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
