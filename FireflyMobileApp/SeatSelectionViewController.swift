//
//  SeatSelectionViewController.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 12/21/15.
//  Copyright © 2015 Me-tech. All rights reserved.
//

import UIKit

class SeatSelectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var seatTableView: UITableView!
    @IBOutlet weak var continueBtn: UIButton!
    var seatSelect = [AnyObject]()
    
    var details = NSMutableArray()
    var passenger = NSArray()
    var passengerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueBtn.layer.cornerRadius = 10
        
        setupLeftButton()
        let defaults = NSUserDefaults.standardUserDefaults()
        let journeys = defaults.objectForKey("journey") as! NSArray
        passenger = defaults.objectForKey("passenger") as! NSArray
        
        var newSeat = NSMutableArray()
        var seatArray = NSMutableArray()
        var seatData = NSMutableArray()
        for info in journeys{
            
            let data = NSMutableDictionary()
            let departureStationName = info["departure_station_name"] as! String
            let departureStation =  info["departure_station"] as! String
            let arrivalStation = info["arrival_station"] as! String
            let arrivalStationName = info["arrival_station_name"] as! String
            let seat = NSMutableArray()
            seatData = info["seat_info"] as! NSMutableArray
            newSeat = seatData.mutableCopy() as! NSMutableArray
            var seatIndex = 0
            while newSeat.count != 0{
                if seatIndex == 3{
                    
                    seatIndex = 0
                    seatArray.addObject(newSeat[0])
                    seat.addObject(seatArray)
                    newSeat.removeObjectAtIndex(0)
                    seatArray = NSMutableArray()
                    
                }else{
                    
                    seatArray.addObject(newSeat[0])
                    newSeat.removeObjectAtIndex(0)
                    seatIndex++
                    
                }
            }
            
            data.setValue(departureStation, forKey: "departure_station")
            data.setValue(departureStationName, forKey: "departure_station_name")
            data.setValue(arrivalStation, forKey: "arrival_station")
            data.setValue(arrivalStationName, forKey: "arrival_station_name")
            data.setValue(seat, forKey: "seat_info")
            
            details.addObject(data)
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Tableview delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return passenger.count
        }else{
            return details[0]["seat_info"]!!.count
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 0
        }else{
            return 40
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = NSBundle.mainBundle().loadNibNamed("directionView", owner: self, options: nil)[0] as! DirectionView
        view.direction.text = "\(details[0]["departure_station"]!!) - \(details[0]["arrival_station"]!!)"
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //print(indexPath.row)
        //let cell = self.seatTableView.cellForRowAtIndexPath(indexPath) as! CustomSeatSelectionTableViewCell
        
        //cell.rowView.backgroundColor = UIColor.yellowColor()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = self.seatTableView.dequeueReusableCellWithIdentifier("PassengerCell", forIndexPath: indexPath) as! CustomSeatSelectionTableViewCell
            
            let passengerDetail = passenger[indexPath.row] as! NSDictionary
            
            let passengerName = "\(passengerDetail["title"]!). \(passengerDetail["first_name"]!) \(passengerDetail["last_name"]!)"
            
            if seatSelect.count != 0{
                var count = 0
                var indexPassenger = 0
                for _ in seatSelect{
                    if indexPath.row == indexPassenger{
                        count++
                    }
                    indexPassenger++
                }
                
                if count != 0{
                    cell.seatNumber.text = seatSelect[indexPath.row]["seat_number"] as? String
                }else{
                    cell.seatNumber.text = ""
                }
            }else{
                cell.seatNumber.text = ""
            }
            
            cell.seatNumber.layer.cornerRadius = 10
            cell.seatNumber.layer.borderWidth = 1
            cell.seatNumber.layer.borderColor = UIColor.blackColor().CGColor
            cell.passengerName.text = passengerName
            cell.selectPassenger.tag = indexPath.row
            cell.removeSeat.tag = indexPath.row
            
            cell.selectPassenger.addTarget(self, action: "selectPassenger:", forControlEvents: .TouchUpInside)
            return cell
        }else {
            let cell = self.seatTableView.dequeueReusableCellWithIdentifier("seatRowCell", forIndexPath: indexPath) as! CustomSeatSelectionTableViewCell
            
            let seatCols = details[0]["seat_info"]!![indexPath.row] as! NSArray
            
            if seatCols[0]["seat_type"] as! String == "preferred"{
                cell.rowView.backgroundColor =  UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
            }else if seatCols[0]["seat_type"] as! String == "standard"{
                cell.rowView.backgroundColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0)
            }else{
                cell.rowView.backgroundColor = UIColor(red: 149/255, green: 201/255, blue: 74/255, alpha: 1.0)
            }
            
            var index = 0
            for seatDetail in seatCols{
                
                if index == 0{
                    
                    self.cellConfig(cell.colABtn, view: cell.colAView, seatDetail: seatDetail as! NSDictionary, row: indexPath.row, action: "selectColASeat:")
                    
                }else if index == 1{
                    
                    self.cellConfig(cell.colCBtn, view: cell.colCView, seatDetail: seatDetail as! NSDictionary, row: indexPath.row, action: "selectColCSeat:")
                    
                }else if index == 2{
                    
                    self.cellConfig(cell.colDBtn, view: cell.colDView, seatDetail: seatDetail as! NSDictionary, row: indexPath.row, action: "selectColDSeat:")
                }else{
                    
                    self.cellConfig(cell.colFBtn, view: cell.colFView, seatDetail: seatDetail as! NSDictionary, row: indexPath.row, action: "selectColFSeat:")
                    
                }
                
                index++
            }
            
            return cell
        }
    }
    
    // MARK: - Helper
    
    func selectPassenger(sender:UIButton){
        
        passengerIndex = sender.tag
        
    }
    
    func selectColASeat(sender:UIButton){
        
        let seatRow = details[0]["seat_info"]!![sender.tag] as! NSArray
        
        let seatDetail = seatRow[0] as! NSDictionary
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColCSeat(sender:UIButton){
        
        let seatRow = details[0]["seat_info"]!![sender.tag] as! NSArray
        
        let seatDetail = seatRow[1] as! NSDictionary
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColDSeat(sender:UIButton){
        
        let seatRow = details[0]["seat_info"]!![sender.tag] as! NSArray
        
        let seatDetail = seatRow[2] as! NSDictionary
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func selectColFSeat(sender:UIButton){
        
        let seatRow = details[0]["seat_info"]!![sender.tag] as! NSArray
        
        let seatDetail = seatRow[3] as! NSDictionary
        
        self.seatSelect(seatDetail, btn: sender)
        
    }
    
    func seatSelect(seatDetail: NSDictionary, btn: UIButton){
        
        if seatSelect.count != 0{
            
            if seatSelect.count == passenger.count{
                seatSelect.removeAtIndex(passengerIndex)
                seatSelect.insert(seatDetail, atIndex: passengerIndex)
                btn.userInteractionEnabled = false
                btn.backgroundColor = UIColor.greenColor()
            }else{
                var indexSeat = 0
                var indexSameSeat = 0
                for seatArr in seatSelect{
                    
                    if seatArr["seat_number"] as! String == seatDetail["seat_number"] as! String{
                        seatSelect.removeAtIndex(indexSeat)
                        indexSameSeat++
                    }
                    indexSeat++
                }
                
                if indexSameSeat == 0{
                    seatSelect.append(seatDetail)
                    passengerIndex = seatSelect.count - 1
                    btn.backgroundColor = UIColor.greenColor()
                    btn.userInteractionEnabled = false
                }else{
                    btn.backgroundColor = UIColor.clearColor()
                    btn.userInteractionEnabled = true
                }
            }
        }else{
            seatSelect.append(seatDetail)
            btn.backgroundColor = UIColor.greenColor()
            btn.userInteractionEnabled = false
        }
        
        self.seatTableView.reloadData()
    }
    
    func cellConfig(btn:UIButton, view:UIView, seatDetail:NSDictionary, row:Int, action:Selector){
        
        if seatDetail["status"] as! String == "available"{
            view.backgroundColor = UIColor.lightGrayColor()
        }else{
            view.backgroundColor = UIColor.redColor()
            btn.userInteractionEnabled = false
        }
        
        if seatSelect.count != 0{
            var indexSameSeat = 0
            for seatArr in seatSelect{
                if seatArr["seat_number"] as! String == seatDetail["seat_number"] as! String{
                    indexSameSeat++
                }
            }
            
            if indexSameSeat != 0{
                btn.backgroundColor = UIColor.greenColor()
                btn.userInteractionEnabled = false
            }else{
                btn.backgroundColor = UIColor.clearColor()
                btn.userInteractionEnabled = true
            }
            
        }else{
            btn.backgroundColor = UIColor.clearColor()
            btn.userInteractionEnabled = true
        }
        
        btn.setTitle(seatDetail["seat_number"] as? String, forState: UIControlState.Normal)
        btn.tag = row
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
    }
    
    @IBAction func continueBtnPressed(sender: AnyObject) {
        
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
