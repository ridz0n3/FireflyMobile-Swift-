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
    
    var departDate = Date()
    var arrivalDate = Date()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditSearchFlightViewController.departureDate(_:)), name: NSNotification.Name(rawValue: "departure"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditSearchFlightViewController.returnDate(_:)), name: NSNotification.Name(rawValue: "return"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return flightDetail.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = editFlightTableView.dequeueReusableCell(withIdentifier: "airportCell", for: indexPath) as! CustomSearchFlightTableViewCell
        
        let flightData = flightDetail[indexPath.section] as! NSDictionary
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let twentyFour = NSLocale(localeIdentifier: "en_GB")
        formater.locale = twentyFour as Locale!
        if (indexPath.section == 0 && !isCheckGoing) || (indexPath.section == 1 && !isCheckReturn){
            cell.bgView.backgroundColor = UIColor.lightGray
        }else{
            cell.bgView.backgroundColor = UIColor.white
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
                    let date = (flightData["departure_date"] as! String).components(separatedBy: "/")
                    
                    let dateStr = formater.date(from: "\(date[2])-\(date[1])-\(date[0])")
                    departDate = dateStr!
                    nonFormatGoingDate = formater.string(from: dateStr!)
                    cell.airportLbl.text = flightData["departure_date"] as? String
                    
                }else{
                    cell.airportLbl.text = goingDate
                }
                
                cell.isUserInteractionEnabled = isCheckGoing
                
            }else{
                if !isChangeReturnDate{
                    let date = (flightData["departure_date"] as! String).components(separatedBy: "/")
                    
                    let dateStr = formater.date(from: "\(date[2])-\(date[1])-\(date[0])")
                    arrivalDate = dateStr!
                    nonFormatReturnDate = formater.string(from: dateStr!)
                    cell.airportLbl.text = flightData["departure_date"] as? String
                    
                }else{
                    cell.airportLbl.text = returnDate
                }
                
                cell.isUserInteractionEnabled = isCheckReturn
            }
            
            cell.airportLbl.tag = indexPath.row
        }
        
        //cell.userInteractionEnabled = userInteract
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2{
            
            if indexPath.section == 0{
                let storyBoard = UIStoryboard(name: "RSDFDatePicker", bundle: nil)
                let gregorianVC = storyBoard.instantiateViewController(withIdentifier: "DatePickerVC") as! RSDFDatePickerViewController
                gregorianVC.dateSelected = departDate
                gregorianVC.isDepart = true
                gregorianVC.calendar = Calendar(identifier: Calendar.Identifier.gregorian)//(calendarIdentifier: NSCalendarIdentifierGregorian)!
                //gregorianVC.calendar.locale = NSLocale.currentLocale()
                gregorianVC.view.backgroundColor = UIColor.orange
                gregorianVC.typeDate = "departure"
                self.present(gregorianVC, animated: true, completion: nil)
            }else{
                let storyBoard = UIStoryboard(name: "RSDFDatePicker", bundle: nil)
                let gregorianVC = storyBoard.instantiateViewController(withIdentifier: "DatePickerVC") as! RSDFDatePickerViewController
                gregorianVC.dateSelected = arrivalDate
                gregorianVC.currentDate = departDate
                gregorianVC.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                //gregorianVC.calendar.locale = NSLocale.currentLocale()
                gregorianVC.view.backgroundColor = UIColor.orange
                gregorianVC.typeDate = "return"
                self.present(gregorianVC, animated: true, completion: nil)
            }
            
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        sectionHeader = Bundle.main.loadNibNamed("FlightHeaderView", owner: self, options: nil)?[0] as! UIView
        
        sectionHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50);
        checkBox.uncheckedColor = UIColor.white
        checkBox.strokeColor = UIColor.orange
        checkBox.checkColor = UIColor.orange
        checkBtn.tag = section
        if (section == 1) {
            wayLbl.text = "RETURN FLIGHT"
            if isCheckReturn{
                checkBox.checkState = M13CheckboxState.checked
            }else{
                checkBox.checkState = M13CheckboxState.unchecked
            }
        }else{
            if isCheckGoing{
                checkBox.checkState = M13CheckboxState.checked
            }else{
                checkBox.checkState = M13CheckboxState.unchecked
            }
        }
        
        checkBtn.addTarget(self, action: #selector(EditSearchFlightViewController.checkSection(_:)), for: .touchUpInside)
        return sectionHeader
        
    }
    
    var nonFormatGoingDate = String()
    var nonFormatReturnDate = String()
    
    func departureDate(_ notif:NSNotification){
        isChangeGoingDate = true
        
        let date = (notif.userInfo!["date"] as? String)!.components(separatedBy: "-")
        goingDate = "\(date[2])/\(date[1])/\(date[0])"
        
        nonFormatGoingDate = notif.userInfo!["date"] as! String
        departDate = stringToDate(notif.userInfo!["date"] as! String)
        editFlightTableView.reloadData()
        
    }
    
    func returnDate(_ notif:NSNotification){
        isChangeReturnDate = true
        let date = (notif.userInfo!["date"] as? String)!.components(separatedBy: "-")
        returnDate = "\(date[2])/\(date[1])/\(date[0])"
        nonFormatReturnDate = notif.userInfo!["date"] as! String
        arrivalDate = stringToDate(nonFormatReturnDate)
        editFlightTableView.reloadData()
        
    }
    
    func checkSection(_ sender:UIButton){
        
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
    
    func getFlightName(_ flightCode : String) -> String{
        
        let flightArr = defaults.object(forKey: "flight") as! [Dictionary<String, AnyObject>]
        var flightName = String()
        for flightData in flightArr{
            
            if flightData["location_code"] as! String == flightCode{
                flightName = flightData["location"] as! String
                break
            }
            
        }
        
        return flightName
        
    }
    
    @IBAction func continueBtnPressed(_ sender: AnyObject) {
        
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
                
                if gDate.compare(rDate) == ComparisonResult.orderedDescending{
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
                    case .success(let successResult):
                        do {
                            
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                
                                if json["flight_type"].string == "MH"{
                                    
                                    let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                    let changeFlightVC = storyboard.instantiateViewController(withIdentifier: "EditMHFlightDetailVC") as! EditMHFlightDetailViewController
                                    changeFlightVC.flightDetail = json["journeys"].arrayValue
                                    
                                    if json["type"] == 1{
                                        changeFlightVC.returnData = json["return_flight"].dictionaryObject! as NSDictionary
                                    }
                                    changeFlightVC.type = json["type"].int!
                                    changeFlightVC.goingData = json["going_flight"].dictionaryObject! as NSDictionary
                                    changeFlightVC.signature = json["signature"].string!
                                    
                                    changeFlightVC.pnr = self.pnr
                                    changeFlightVC.bookId = "\(self.bookId)"
                                    changeFlightVC.signature = self.signature
                                    self.navigationController!.pushViewController(changeFlightVC, animated: true)
                                    
                                }else{
                                    
                                    let storyboard = UIStoryboard(name: "ManageFlight", bundle: nil)
                                    let changeFlightVC = storyboard.instantiateViewController(withIdentifier: "EditFlightDetailVC") as! EditFlightDetailViewController
                                    changeFlightVC.flightDetail = json["journeys"].arrayValue
                                    
                                    if json["type"] == 1{
                                        changeFlightVC.returnData = json["return_flight"].dictionaryObject! as NSDictionary
                                    }
                                    changeFlightVC.type = json["type"].int!
                                    changeFlightVC.goingData = json["going_flight"].dictionaryObject! as NSDictionary
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
                                        _ = self.navigationController?.popToViewController(views, animated: true)
                                        AnalyticsManager.sharedInstance.logScreen(GAConstants.homeScreen)
                                    }
                                }
                            }
                            hideLoading()
                        }
                        catch {
                            
                        }
                        
                    case .failure(let failureResult):
                        
                        hideLoading()
                        showErrorMessage(failureResult.localizedDescription)
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
