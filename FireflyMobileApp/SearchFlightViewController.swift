//
//  SearchFlightViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftyJSON

class SearchFlightViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var hideRow : Bool = false
    var arrival:String = "ARRIVAL AIRPORT"
    var departure:String = "DEPARTURE AIRPORT"
    var arrivalDateLbl:String = "RETURN DATE"
    var departureDateLbl:String = "DEPARTURE DATE"
    
    var departDate = Date()
    var arrivalDate = Date()
    var arrivalSelected = Int()
    var departureSelected = Int()
    
    var departureText = String()
    var arrivalText = String()
    var type : Int = 1
    var validate : Bool = false
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchFlightTableView: UITableView!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10
        self.searchFlightTableView.tableHeaderView = headerView
        
        setupLeftButton()
        getDepartureAirport("search")
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchFlightViewController.departureDate(_:)), name: NSNotification.Name(rawValue: "departure"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchFlightViewController.returnDate(_:)), name: NSNotification.Name(rawValue: "return"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchFlightViewController.departurePicker(_:)), name: NSNotification.Name(rawValue: "departureSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchFlightViewController.arrivalPicker(_:)), name: NSNotification.Name(rawValue: "arrivalSelected"), object: nil)
        AnalyticsManager.sharedInstance.logScreen(GAConstants.searchFlightScreen)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 30
        }else if indexPath.row == 5 {
            return 104
        }else if indexPath.row == 4 && hideRow {
            return 0.0
        }else{
            return 50
        }
        
    }
    
    func toogleAlpha(){
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            
            let cell = self.searchFlightTableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! CustomSearchFlightTableViewCell
            
            cell.returnBtn.addTarget(self, action: #selector(SearchFlightViewController.btnClick(_:)), for: .touchUpInside)
            cell.oneWayBtn.addTarget(self, action: #selector(SearchFlightViewController.btnClick(_:)), for: .touchUpInside)
            
            return cell
        }else if indexPath.row == 5 {
            let cell = self.searchFlightTableView.dequeueReusableCell(withIdentifier: "passengerCell", for: indexPath) as! CustomSearchFlightTableViewCell
            return cell
            
        }else{
            let cell = self.searchFlightTableView.dequeueReusableCell(withIdentifier: "airportCell", for: indexPath) as! CustomSearchFlightTableViewCell
            
            if indexPath.row == 1 {
                
                cell.iconImg.image = UIImage(named: "departure_icon")
                cell.airportLbl.text = departure
                cell.airportLbl.tag = indexPath.row
                
            }else if indexPath.row == 2{
                
                cell.iconImg.image = UIImage(named: "arrival_icon")
                cell.airportLbl.text = arrival
                cell.airportLbl.tag = indexPath.row
                cell.lineStyle.image = UIImage(named: "lines")
                
            }else if indexPath.row == 3{
                
                cell.iconImg.image = UIImage(named: "date_icon")
                cell.airportLbl.text = departureDateLbl
                cell.airportLbl.tag = indexPath.row
                
            }else{
                
                cell.iconImg.image = UIImage(named: "date_icon")
                cell.airportLbl.text = arrivalDateLbl
                cell.airportLbl.tag = indexPath.row
                cell.lineStyle.image = UIImage(named: "lines")
                
            }
            return cell;
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = self.searchFlightTableView.cellForRow(at: indexPath) as! CustomSearchFlightTableViewCell
        
        if indexPath.row == 1{
            //let sender = cell.airportLbl as UILabel
            
            /*
            let picker = ActionSheetStringPicker(title: "", rows: pickerRow, initialSelection: departureSelected, target: self, successAction: #selector(SearchFlightViewController.objectSelected(_:element:)), cancelAction: #selector(self.actionPickerCancelled(_:)), origin: sender)
            picker.showActionSheetPicker()*/
            
            let storyboard = UIStoryboard(name: "CustomFlightPicker", bundle: nil)
            let loadingVC = storyboard.instantiateViewController(withIdentifier: "CustomFlightPickerVC") as! CustomFlightPickerViewController
            loadingVC.picker = pickerRow
            loadingVC.selectPicker = departureSelected
            loadingVC.destinationType = "departure"
            self.navigationController?.present(loadingVC, animated: true, completion: nil)
 
        }else if indexPath.row == 2{
            
            if pickerTravel.count != 0{
                
                let storyboard = UIStoryboard(name: "CustomFlightPicker", bundle: nil)
                let loadingVC = storyboard.instantiateViewController(withIdentifier: "CustomFlightPickerVC") as! CustomFlightPickerViewController
                loadingVC.picker = pickerTravel
                loadingVC.selectPicker = arrivalSelected
                loadingVC.destinationType = "arrival"
                self.navigationController?.present(loadingVC, animated: true, completion: nil)
                
                /*
                let sender = cell.airportLbl as UILabel
                let picker = ActionSheetStringPicker(title: "", rows: pickerTravel, initialSelection: arrivalSelected, target: self, successAction: #selector(SearchFlightViewController.objectSelected(_:element:)), cancelAction: #selector(self.actionPickerCancelled(_:)), origin: sender)
                picker.showActionSheetPicker()
                */
                
            }
            
        }else if indexPath.row == 3{
            
            let storyBoard = UIStoryboard(name: "RSDFDatePicker", bundle: nil)
            let gregorianVC = storyBoard.instantiateViewController(withIdentifier: "DatePickerVC") as! RSDFDatePickerViewController
            gregorianVC.calendar = Calendar(identifier: Calendar.Identifier.gregorian)//(calendarIdentifier: NSCalendarIdentifierGregorian)!
            gregorianVC.isDepart = true
            gregorianVC.dateSelected = departDate
            //gregorianVC.calendar.locale = NSLocale.currentLocale()
            gregorianVC.view.backgroundColor = UIColor.orange
            gregorianVC.typeDate = "departure"
            self.present(gregorianVC, animated: true, completion: nil)
            
            
            
        }else if indexPath.row == 4{
            
            let storyBoard = UIStoryboard(name: "RSDFDatePicker", bundle: nil)
            let gregorianVC = storyBoard.instantiateViewController(withIdentifier: "DatePickerVC") as! RSDFDatePickerViewController
            gregorianVC.currentDate = departDate
            gregorianVC.dateSelected = arrivalDate
            gregorianVC.calendar = Calendar(identifier: Calendar.Identifier.gregorian)//Calendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            //gregorianVC.calendar.locale = NSLocale.currentLocale()
            gregorianVC.view.backgroundColor = UIColor.orange
            gregorianVC.typeDate = "return"
            self.present(gregorianVC, animated: true, completion: nil)
            
        }
        
    }
    
    func objectSelected(_ index :NSNumber, element:AnyObject){
        
        let txtLbl = element as! UILabel
        
        if txtLbl.tag == 1{
            departureSelected = index.intValue
            departure = "\(location[departureSelected]["location"] as! String) (\(location[departureSelected]["location_code"] as! String))"
            txtLbl.text = departure
            arrivalSelected = 0
            pickerTravel.removeAll()
            travel.removeAll()
            arrival = "ARRIVAL AIRPORT"
            self.searchFlightTableView.reloadData()
            getArrivalAirport((location[departureSelected]["location_code"] as? String)!, module : "search")
        }else{
            arrivalSelected = index.intValue
            arrival = "\(travel[arrivalSelected]["travel_location"] as! String) (\(travel[arrivalSelected]["travel_location_code"] as! String))"
            txtLbl.text = arrival
            
        }
        
    }
    
    func btnClick(_ sender : UIButton){
        
        let btnPress: UIButton = sender as UIButton
        
        let indexCell = IndexPath(item: 0, section: 0)
        let cell = self.searchFlightTableView.cellForRow(at: indexCell) as! CustomSearchFlightTableViewCell
        
        if btnPress.tag == 1 {
            
            type = 1
            cell.returnBtn.isUserInteractionEnabled = false
            cell.oneWayBtn.isUserInteractionEnabled = true
            
            cell.returnBtn.backgroundColor = UIColor.white
            cell.oneWayBtn.backgroundColor = UIColor.lightGray
            arrivalDateLbl = "RETURN DATE"
            self.searchFlightTableView.reloadData()
            hideRow = false;
        }else{
            
            type = 0
            cell.returnBtn.isUserInteractionEnabled = true
            cell.oneWayBtn.isUserInteractionEnabled = false
            
            cell.returnBtn.backgroundColor = UIColor.lightGray
            cell.oneWayBtn.backgroundColor = UIColor.white
            arrivalDateLbl = "RETURN DATE"
            self.searchFlightTableView.reloadData()
            hideRow = true;
        }
        
        self.searchFlightTableView.beginUpdates()
        self.searchFlightTableView.endUpdates()
        
    }
    
    @IBAction func continueButtonPressed(_ sender: AnyObject) {
        
        let indexCell = IndexPath(item: 5, section: 0)
        let cell2 = self.searchFlightTableView.cellForRow(at: indexCell) as! CustomSearchFlightTableViewCell
        searchFlightValidation()
        if validate == true{
            
            if Int(cell2.infantCount.text!)! > Int(cell2.adultCount.text!)!{
                animateCell(cell2)
                showErrorMessage("Number of infant must lower or equal with adult.")
            }else{
                
                defaults.set(cell2.adultCount.text!, forKey: "adult")
                defaults.set(cell2.infantCount.text!, forKey: "infants")
                defaults.set(type, forKey: "type")
                defaults.synchronize()
                
                var username = ""
                var password = ""
                
                if try! LoginManager.sharedInstance.isLogin(){
                    let userInfo = defaults.object(forKey: "userInfo") as! NSMutableDictionary
                    username = "\(userInfo["username"] as! String)"
                    password = "\(userInfo["password"] as! String)"
                    
                }
                
                showLoading()
                FireFlyProvider.request(.SearchFlight(type, location[departureSelected]["location_code"]! as! String, travel[arrivalSelected]["travel_location_code"]! as! String, departureText, arrivalText, cell2.adultCount.text!, cell2.infantCount.text!, username, password), completion: { (result) -> () in
                    
                    switch result {
                    case .success(let successResult):
                        do {
                            let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))
                            
                            if json["status"] == "success"{
                                defaults.set(json["signature"].string, forKey: "signature")
                                defaults.synchronize()
                                
                                if json["flight_type"].string == "MH"{
                                    defaults.setValue(json["flight_type"].string, forKey: "flightType")
                                    defaults.synchronize()
                                    let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                    let flightDetailVC = storyboard.instantiateViewController(withIdentifier: "MHFlightDetailVC") as! AddMHFlightDetailViewController
                                    flightDetailVC.flightDetail = json["journeys"].arrayValue
                                    self.navigationController!.pushViewController(flightDetailVC, animated: true)
                                }else{
                                    defaults.setValue(json["flight_type"].string, forKey: "flightType")
                                    defaults.synchronize()
                                    let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                                    let flightDetailVC = storyboard.instantiateViewController(withIdentifier: "FlightDetailVC") as! AddFlightDetailViewController
                                    flightDetailVC.flightDetail = json["journeys"].arrayValue
                                    self.navigationController!.pushViewController(flightDetailVC, animated: true)
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
    
    func searchFlightValidation(){
        _ = IndexPath(item: 5, section: 0) //.init(item: 5, section: 0)
        
        var count = Int()
        
        if departure == "DEPARTURE AIRPORT"{
            let indexCell = IndexPath(item: 1, section: 0)
            let cell = self.searchFlightTableView.cellForRow(at: indexCell) as! CustomSearchFlightTableViewCell
            animateCell(cell)
            count += 1
            
            showErrorMessage("Please choose your departure airport.")
        }else if arrival == "ARRIVAL AIRPORT"{
            let indexCell = IndexPath(item: 2, section: 0)
            let cell = self.searchFlightTableView.cellForRow(at: indexCell) as! CustomSearchFlightTableViewCell
            animateCell(cell)
            count += 1
            
            showErrorMessage("Please choose your arrival airport.")
        }else if departureDateLbl == "DEPARTURE DATE"{
            let indexCell = IndexPath(item: 3, section: 0)
            let cell = self.searchFlightTableView.cellForRow(at: indexCell) as! CustomSearchFlightTableViewCell
            animateCell(cell)
            count += 1
            
            showErrorMessage("Please choose your departure date.")
        }else if arrivalDateLbl == "RETURN DATE" && type == 1{
            let indexCell = IndexPath(item: 4, section: 0)
            let cell = self.searchFlightTableView.cellForRow(at: indexCell) as! CustomSearchFlightTableViewCell
            animateCell(cell)
            count += 1
            
            showErrorMessage("Please choose your return date.")
        }else if arrivalDateLbl == "RETURN DATE" && type == 0{
            arrivalDateLbl = ""
        }
        
        if count == 0{
            validate = true
        }else{
            validate = false
        }
    }
    
    func departureDate(_ notif:NSNotification){
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        
        if arrivalDateLbl != "RETURN DATE"{
            arrivalDateLbl = "RETURN DATE"
        }
        
        departDate = formater.date(from: notif.userInfo!["date"] as! String)!
        departureText = (notif.userInfo!["date"] as? String)!
        arrivalText = (notif.userInfo!["date"] as? String)!
        arrivalDate = formater.date(from: notif.userInfo!["date"] as! String)!
        
        let date = (notif.userInfo!["date"] as? String)!.components(separatedBy: "-")
        departureDateLbl = "\(date[2])/\(date[1])/\(date[0])"
        arrivalDateLbl = "\(date[2])/\(date[1])/\(date[0])"
        searchFlightTableView.reloadData()
        
    }
    
    func returnDate(_ notif:NSNotification){
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        arrivalText = (notif.userInfo!["date"] as? String)!
        arrivalDate = formater.date(from: notif.userInfo!["date"] as! String)!
        let date = (notif.userInfo!["date"] as? String)!.components(separatedBy: "-")
        arrivalDateLbl = "\(date[2])/\(date[1])/\(date[0])"
        searchFlightTableView.reloadData()
        
    }
    
    func departurePicker(_ notif:NSNotification){
        let index = notif.userInfo!["index"] as! Int
        
        departureSelected = index
        departure = "\(location[departureSelected]["location"] as! String) (\(location[departureSelected]["location_code"] as! String))"
        //txtLbl.text = departure
        arrivalSelected = 0
        pickerTravel.removeAll()
        travel.removeAll()
        arrival = "ARRIVAL AIRPORT"
        self.searchFlightTableView.reloadData()
        getArrivalAirport((location[departureSelected]["location_code"] as? String)!, module : "search")
        
        
    }
    
    func arrivalPicker(_ notif:NSNotification){
        let index = notif.userInfo!["index"] as! Int
        
        arrivalSelected = index
        arrival = "\(travel[arrivalSelected]["travel_location"] as! String) (\(travel[arrivalSelected]["travel_location_code"] as! String))"
        self.searchFlightTableView.reloadData()
        
    }
    
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerRow.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerRow[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //textfieldBizCat.text = "\(bizCat[row])"
        
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
