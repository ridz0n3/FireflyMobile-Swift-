//
//  SearchFlightViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 11/16/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SearchFlightViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var hideRow : Bool = false
    var arrival:String = "ARRIVAL AIRPORT"
    var departure:String = "DEPARTURE AIRPORT"
    var arrivalDateLbl:String = "RETURN DATE"
    var departureDateLbl:String = "DEPARTURE DATE"
    
    var departureDate = NSDate()
    var arrivalDate = NSDate()
    var arrivalSelected = Int()
    var departureSelected = Int()
    
    var type : Int = 1
    var validate : Bool = false
    
    @IBOutlet weak var searchFlightTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)[0] as! HeaderView
        header.lvlImg.image = UIImage(named: "book_flight1")
        
        self.searchFlightTableView.tableHeaderView = header
        
        setupLeftButton()
        getDepartureAirport()
        //returnButton.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
        //oneWayButton.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            
            let cell = self.searchFlightTableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! CustomSearchFlightTableViewCell
            
            cell.returnBtn.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
            cell.oneWayBtn.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
            
            return cell
        }else if indexPath.row == 5 {
            let cell = self.searchFlightTableView.dequeueReusableCellWithIdentifier("passengerCell", forIndexPath: indexPath) as! CustomSearchFlightTableViewCell
            return cell
            
        }else{
            let cell = self.searchFlightTableView.dequeueReusableCellWithIdentifier("airportCell", forIndexPath: indexPath) as! CustomSearchFlightTableViewCell
            
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = self.searchFlightTableView.cellForRowAtIndexPath(indexPath) as! CustomSearchFlightTableViewCell
        
        if indexPath.row == 1{
            let sender = cell.airportLbl as UILabel
            let picker = ActionSheetStringPicker(title: "", rows: pickerRow, initialSelection: departureSelected, target: self, successAction: Selector("objectSelected:element:"), cancelAction: "actionPickerCancelled:", origin: sender)
            picker.showActionSheetPicker()
            
        }else if indexPath.row == 2{
            
            if pickerTravel.count != 0{
                let sender = cell.airportLbl as UILabel
                let picker = ActionSheetStringPicker(title: "", rows: pickerTravel, initialSelection: arrivalSelected, target: self, successAction: Selector("objectSelected:element:"), cancelAction: "actionPickerCancelled:", origin: sender)
                picker.showActionSheetPicker()
                
            }
            
        }else if indexPath.row == 3{
            
            let sender = cell.airportLbl as UILabel
            
            let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.Date, selectedDate: departureDate, target: self, action: "datePicked:element:", origin: sender)
            datePicker.minimumDate = NSDate()
            datePicker.showActionSheetPicker()
            
        }else if indexPath.row == 4{
            
            let sender = cell.airportLbl as UILabel
            
            let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.Date, selectedDate: arrivalDate, target: self, action: "datePicked:element:", origin: sender)
            datePicker.minimumDate = departureDate
            datePicker.showActionSheetPicker()
            
        }
        
    }
    
    func datePicked(date:NSDate, element:AnyObject){
        
        let textLbl = element as! UILabel
        
        if textLbl.tag == 3{
            departureDate = date
            
            departureDateLbl = formatDate(date)
            
            if arrivalDateLbl != "RETURN DATE"{
                
                if arrivalDate.compare(departureDate) == NSComparisonResult.OrderedAscending{
                    arrivalDateLbl = departureDateLbl
                    self.searchFlightTableView.reloadData()
                }
                
            }
            arrivalDate = date
            textLbl.text = departureDateLbl
        }else{
            arrivalDate = date
            
            arrivalDateLbl = formatDate(date)
            textLbl.text = arrivalDateLbl
        }
        

    }
    
    func objectSelected(index :NSNumber, element:AnyObject){
        
        let txtLbl = element as! UILabel
        
        if txtLbl.tag == 1{
            departureSelected = index.integerValue
            departure = (location[departureSelected]["location"] as? String)!
            txtLbl.text = departure
            arrivalSelected = 0
            pickerTravel.removeAll()
            travel.removeAll()
            arrival = "ARRIVAL AIRPORT"
            self.searchFlightTableView.reloadData()
            getArrivalAirport((location[departureSelected]["location_code"] as? String)!)
        }else{
            arrivalSelected = index.integerValue
            arrival = (travel[arrivalSelected]["travel_location"] as? String)!
            txtLbl.text = arrival

        }
        
    }
    
    func btnClick(sender : UIButton){
        
        let btnPress: UIButton = sender as UIButton
        
        let indexCell = NSIndexPath.init(forItem: 0, inSection: 0)
        let cell = self.searchFlightTableView.cellForRowAtIndexPath(indexCell) as! CustomSearchFlightTableViewCell
        
        if btnPress.tag == 1 {
            
            type = 1
            cell.returnBtn.userInteractionEnabled = false
            cell.oneWayBtn.userInteractionEnabled = true
            
            cell.returnBtn.backgroundColor = UIColor.whiteColor()
            cell.oneWayBtn.backgroundColor = UIColor.lightGrayColor()
            arrivalDateLbl = "RETURN DATE"
            self.searchFlightTableView.reloadData()
            hideRow = false;
        }else{
            
            type = 0
            cell.returnBtn.userInteractionEnabled = true
            cell.oneWayBtn.userInteractionEnabled = false
            
            cell.returnBtn.backgroundColor = UIColor.lightGrayColor()
            cell.oneWayBtn.backgroundColor = UIColor.whiteColor()
            arrivalDateLbl = "RETURN DATE"
            self.searchFlightTableView.reloadData()
            hideRow = true;
        }
        
        self.searchFlightTableView.beginUpdates()
        self.searchFlightTableView.endUpdates()
        
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        let indexCell = NSIndexPath.init(forItem: 5, inSection: 0)
        let cell2 = self.searchFlightTableView.cellForRowAtIndexPath(indexCell) as! CustomSearchFlightTableViewCell
        searchFlightValidation()
        if validate == true{
            
            if Int(cell2.infantCount.text!)! > Int(cell2.adultCount.text!)!{
                animateCell(cell2)
                showToastMessage("Number of infant must lower or equal with adult.")
            }else{
                let parameters:[String:AnyObject] = [
                    "type" : type,
                    "departure_station" : location[departureSelected]["location_code"]!,
                    "arrival_station": travel[arrivalSelected]["travel_location_code"]!,
                    "departure_date": departureDateLbl,
                    "return_date": arrivalDateLbl,
                    "adult": cell2.adultCount.text!,
                    "infant": cell2.infantCount.text!,
                    "signature": "",
                ]
                
                let manager = WSDLNetworkManager()
                
                showHud()
                manager.sharedClient().createRequestWithService("Search", withParams: parameters, completion: { (result) -> Void in
                    self.hideHud()
                    
                    if result["status"] as! String == "success"{
                        
                        let storyboard = UIStoryboard(name: "BookFlight", bundle: nil)
                        let flightDetailVC = storyboard.instantiateViewControllerWithIdentifier("FlightDetailVC") as! FlightDetailViewController
                        flightDetailVC.flightDetail = result["journeys"] as! NSArray
                        self.navigationController!.pushViewController(flightDetailVC, animated: true)
                        
                    }
                })
            }
        }else{
            showToastMessage("Please Select All Field")
        }
        
    }
    
    func searchFlightValidation(){
        let indexCell = NSIndexPath.init(forItem: 5, inSection: 0)
        let cell2 = self.searchFlightTableView.cellForRowAtIndexPath(indexCell) as! CustomSearchFlightTableViewCell
        
        var count = Int()
        if arrival == "ARRIVAL AIRPORT"{
            let indexCell = NSIndexPath.init(forItem: 2, inSection: 0)
            let cell = self.searchFlightTableView.cellForRowAtIndexPath(indexCell) as! CustomSearchFlightTableViewCell
            animateCell(cell)
            count++
        }
        
        if departure == "DEPARTURE AIRPORT"{
            let indexCell = NSIndexPath.init(forItem: 1, inSection: 0)
            let cell = self.searchFlightTableView.cellForRowAtIndexPath(indexCell) as! CustomSearchFlightTableViewCell
            animateCell(cell)
            count++
        }
        
        if departureDateLbl == "DEPARTURE DATE"{
            let indexCell = NSIndexPath.init(forItem: 3, inSection: 0)
            let cell = self.searchFlightTableView.cellForRowAtIndexPath(indexCell) as! CustomSearchFlightTableViewCell
            animateCell(cell)
            count++
        }
        
        if arrivalDateLbl == "RETURN DATE" && type == 1{
            let indexCell = NSIndexPath.init(forItem: 4, inSection: 0)
            let cell = self.searchFlightTableView.cellForRowAtIndexPath(indexCell) as! CustomSearchFlightTableViewCell
            animateCell(cell)
            count++
        }else if arrivalDateLbl == "RETURN DATE" && type == 0{
            arrivalDateLbl = ""
        }
        
        if cell2.adultCount.text == "0"{
            animateCell(cell2)
            count++
        }
        
        if count == 0{
            validate = true
        }else{
            validate = false
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
